USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAlmacenesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerAlmacenesPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Almacenes);
	END;
	--Obtener informacion de Vehiculos y convertilas a json
	;WITH AlmacenTmp AS
						(
							SELECT Almacenestabla.[Id]
								  ,Almacenestabla.[Nombre]
								  --,Almacenestabla.[CentroDistribucionId] => Un join a la tabla correspondiente para recuperar el valor
								  --,Almacenestabla.[ColaboradorId] => Un join a la tabla correspondiente para recuperar el valor
								  ,Almacenestabla.[Referencia]
								  ,Almacenestabla.[Usuario]
								  ,Almacenestabla.[Eliminado]
								  ,Almacenestabla.[FechaCreacion]
								  ,Almacenestabla.[Trail],

								  ------- Tablas relacionadas con el modelo
					    		Almacenestabla.CentroDistribucionId,
								JSON_QUERY((SELECT LTRIM(RTRIM(CentrosDistribuciones.Nombre)) AS Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS CentroDistribucion,

								Almacenestabla.ColaboradorId,
								JSON_QUERY((SELECT LTRIM(RTRIM(Colaboradores.Nombre)) AS Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador

FROM [Despachos].[Almacenes] Almacenestabla
-------- Creacion de JOINS
INNER JOIN Operadores.CentrosDistribuciones ON CentrosDistribuciones.Id = Almacenestabla.CentroDistribucionId
INNER JOIN Operadores.Colaboradores ON Colaboradores.Id = Almacenestabla.ColaboradorId
WHERE Almacenestabla.Eliminado = 1 AND (@busqueda = '' OR Almacenestabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' OR Almacenestabla.Referencia LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Despachos.Almacenes almacen WHERE almacen.Eliminado = 1 AND (@busqueda = '' OR almacen.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'  OR almacen.Referencia LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'  ))AS TotalRows,
			(	
				SELECT * FROM AlmacenTmp	
				ORDER BY AlmacenTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
