USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerColoresPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Vehiculos].[uspObtenerColoresPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Colores);
	END;
	--Obtener informacion de Vehiculos y convertilas a json
	;WITH ColorTmp AS
						(
							SELECT Colorestabla.[Id]
								  ,Colorestabla.[Nombre]
								  ,Colorestabla.[Usuario]
								  ,Colorestabla.[Eliminado]
								  ,Colorestabla.[FechaCreacion]
								  ,Colorestabla.[Trail]
					    						
FROM [Vehiculos].[Colores] Colorestabla
-------- Creacion de JOINS
WHERE Colorestabla.Eliminado = 1 AND (@busqueda = '' OR Colorestabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Colores WHERE Colores.Eliminado = 1 AND (@busqueda = '' OR Colores.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'   ))AS TotalRows,
			(	
				SELECT * FROM ColorTmp	
				ORDER BY ColorTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
