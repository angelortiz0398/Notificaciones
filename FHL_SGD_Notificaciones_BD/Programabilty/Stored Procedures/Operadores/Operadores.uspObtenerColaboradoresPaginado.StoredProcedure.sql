USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspObtenerColaboradoresPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Operadores].[uspObtenerColaboradoresPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(300) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM [Operadores].[Colaboradores]);
			END;
		
		;WITH CteTmp AS(
			SELECT Colaboradores.[Id]
				  ,Colaboradores.[Nombre]
				  ,Colaboradores.[RFC]
				  ,Colaboradores.[Identificacion]
				  ,Colaboradores.[TipoPerfilesId]
				  ,Colaboradores.[CentroDistribucionesId]
				  ,Colaboradores.[NSS]
				  ,Colaboradores.[CorreoElectronico]
				  ,Colaboradores.[Telefono]
				  ,Colaboradores.[IMEI]
				  --,Colaboradores.Habilidades
				  ,(
						STUFF(
							(
								SELECT ', ' + Nombre 
								FROM Operadores.HabilidadesColaboradores
								WHERE Id IN (
									SELECT CAST(JSON_VALUE(value, '$.Id') AS INT)
									FROM OPENJSON
										(
											(
												SELECT Habilidades
												FROM Operadores.Colaboradores
												WHERE Colaboradores.Id = ColaboradoresPivote.Id
											), '$'
										)
								)
								FOR XML PATH ('')
							)
						,1,2,'')
					) AS Habilidades
				  --,Colaboradores.[TipoVehiculo]
				  ,(
						STUFF(
							(
								SELECT ', ' + Nombre 
								FROM Vehiculos.Tipos
								WHERE Id IN (
									SELECT CAST(JSON_VALUE(value, '$.Id') AS INT)
									FROM OPENJSON
										(
											(
												SELECT TipoVehiculo
												FROM Operadores.Colaboradores
												WHERE Colaboradores.Id = ColaboradoresPivote.Id
											), '$'
										)
								)
								FOR XML PATH ('')
							)
						,1,2,'')
					) AS TipoVehiculo
				  ,Colaboradores.[Estado]
				  ,Colaboradores.[Comentarios]
				  ,Colaboradores.[UltimoAcceso]
				  ,Colaboradores.[Usuario]
				  ,Colaboradores.[Eliminado]
				  ,Colaboradores.[FechaCreacion]
				  ,Colaboradores.[Trail]
				  ,JSON_QUERY((SELECT TipoPerfil.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoPerfiles
				  ,JSON_QUERY((SELECT CentroDistribucion.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS CentroDistribuciones
			  FROM  [Operadores].[Colaboradores] Colaboradores
					INNER JOIN Operadores.Colaboradores ColaboradoresPivote ON Colaboradores.Id = ColaboradoresPivote.Id
		  			LEFT JOIN Operadores.TiposPerfiles TipoPerfil ON TipoPerfil.Id = Colaboradores.TipoPerfilesId
					LEFT JOIN Operadores.CentrosDistribuciones CentroDistribucion ON CentroDistribucion.Id = Colaboradores.CentroDistribucionesId
				------------------------------------------------------------------------------------
				WHERE Colaboradores.Eliminado = 1 AND (@busqueda = '' OR Colaboradores.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la informaci�n de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM [Operadores].[Colaboradores] Colaboradores WHERE Colaboradores.Eliminado = 1 AND (@busqueda = '' OR LOWER(Colaboradores.Nombre) LIKE '%' + LOWER(LTRIM(RTRIM(@busqueda))) + '%')) AS TotalRows,
			(
				SELECT CteTmp.*
				FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
