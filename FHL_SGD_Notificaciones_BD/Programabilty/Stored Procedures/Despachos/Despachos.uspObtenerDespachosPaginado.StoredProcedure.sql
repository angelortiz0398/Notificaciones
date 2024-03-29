USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerDespachosPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Despachos].[uspObtenerDespachosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Despachos);
			END;
		
		;WITH CteTmp AS(
			Select 
				[Despachos].[Id]
			  ,[FolioDespacho]
			  ,[Borrador]
			  ,[Origen]
			  ,[Destino]
			  ,[VehiculoId]
			  ,[VehiculoTercero]
			  ,[RemolqueId]
			  ,[OperadorId]
			  ,[Custodia]
			  ,[Auxiliares]
			  ,[Peligroso]
			  ,[RutaId]
			  ,[ServiciosAdicionales]
			  ,[AndenId]
			  ,[EstatusId]
			  ,[OcupacionEfectiva]
			  ,[TiempoEntrega]
			  ,[Despachos].[Usuario]
			  ,[Despachos].[Eliminado]
			  ,[Despachos].[FechaCreacion]
			  ,[Despachos].[Trail]
				---------------------------------------------------------------------------------
				--Json para el Objeto de Vehiculo
				,JSON_QUERY((SELECT Vehiculos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculo
				--Json Para el Objeto Operador 
				,JSON_QUERY((SELECT Operadores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Operador
					--Json Para el Objeto Remolque
				,JSON_QUERY((SELECT Remolques.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Remolque
					--Json Para el Objeto Anden
				,JSON_QUERY((SELECT Andenes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Anden
					--Json Para el Objeto Ruta
				,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta
				----------------------------------------------------------------------------------
				From [Despachos].[Despachos] Despachos				
				--Definir LEFT JOIN para traer el Objeto Vehiculo
				LEFT JOIN Vehiculos.Vehiculos Vehiculos ON Vehiculos.Id = Despachos.VehiculoId
				--Definir LEFT JOIN para traer el Objeto Operador
				LEFT JOIN Operadores.Colaboradores Operadores ON Operadores.Id = Despachos.OperadorId
				--Definir LEFT JOIN para traer el Objeto Remolque
				LEFT JOIN Remolques.Remolques Remolques ON Remolques.Id = Despachos.RemolqueId
				--Definir LEFT JOIN para traer el Objeto Anden
				LEFT JOIN Despachos.Andenes Andenes ON Andenes.Id = Despachos.AndenId
				--Definir LEFT JOIN para traer el Objeto Ruta
				LEFT JOIN Operadores.Rutas Rutas ON Rutas.Id = Despachos.RutaId
				------------------------------------------------------------------------------------
				WHERE	Despachos.Eliminado = 1 AND (@busqueda = '' OR Despachos.FolioDespacho LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Despachos WHERE Despachos.Eliminado = 1 AND (@busqueda = '' OR Despachos.FolioDespacho LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
