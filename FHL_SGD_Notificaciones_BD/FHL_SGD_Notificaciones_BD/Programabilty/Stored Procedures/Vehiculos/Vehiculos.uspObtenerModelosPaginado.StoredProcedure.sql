USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerModelosPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Vehiculos].[uspObtenerModelosPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Modelos);
	END;
	--Obtener informacion de Vehiculos y convertilas a json
	;WITH ModeloTmp AS
						(
							SELECT ModelosTabla.[Id]
								  ,ModelosTabla.[Nombre]
								  --,ModelosTabla.[MarcaId] => Un join a la tabla correspondiente para recuperar el valor
								  ,ModelosTabla.[Usuario]
								  ,ModelosTabla.[Eliminado]
								  ,ModelosTabla.[FechaCreacion]
								  ,ModelosTabla.[Trail],
					------- Tablas relacionadas con el modelo
					ModelosTabla.MarcaId,
					JSON_QUERY((SELECT LTRIM(RTRIM(Marcas.Nombre)) AS Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Marca     
						
FROM [Vehiculos].[Modelos] ModelosTabla
-------- Creacion de JOINS
INNER JOIN Vehiculos.Marcas Marcas ON Marcas.Id = ModelosTabla.MarcaId 
WHERE ModelosTabla.Eliminado = 1 AND (@busqueda = '' OR ModelosTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Modelos WHERE Modelos.Eliminado = 1 AND (@busqueda = '' OR Modelos.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'   ))AS TotalRows,
			(	
				SELECT * FROM ModeloTmp	
				ORDER BY ModeloTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
