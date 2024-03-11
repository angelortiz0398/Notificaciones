USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerMarcasPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Vehiculos].[uspObtenerMarcasPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Marcas);
	END;
	--Obtener informacion de Vehiculos y convertilas a json
	;WITH MarcaTmp AS
						(
							SELECT Marcastabla.[Id]
								  ,Marcastabla.[Nombre]
								  ,Marcastabla.[Usuario]
								  ,Marcastabla.[Eliminado]
								  ,Marcastabla.[FechaCreacion]
								  ,Marcastabla.[Trail]
					    						
FROM [Vehiculos].[Marcas] Marcastabla
-------- Creacion de JOINS
WHERE Marcastabla.Eliminado = 1 AND (@busqueda = '' OR Marcastabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Marcas WHERE Marcas.Eliminado = 1 AND (@busqueda = '' OR Marcas.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'   ))AS TotalRows,
			(	
				SELECT * FROM MarcaTmp	
				ORDER BY MarcaTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
