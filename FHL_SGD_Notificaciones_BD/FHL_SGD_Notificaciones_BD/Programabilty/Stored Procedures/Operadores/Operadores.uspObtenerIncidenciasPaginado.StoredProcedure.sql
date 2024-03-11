USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspObtenerIncidenciasPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Operadores].[uspObtenerIncidenciasPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
AS
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize =0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Incidencias);
	END;
	--Obtener informacion de Incidencias y convertilas a json
	;WITH IncidenciaTmp AS
						(
							SELECT IncidenciasTabla.[Id]
								  ,IncidenciasTabla.[Nombre]
								  ,IncidenciasTabla.[Puntos]
								  ,IncidenciasTabla.[Usuario]
								  ,IncidenciasTabla.[Eliminado]
								  ,IncidenciasTabla.[FechaCreacion]
								  ,IncidenciasTabla.[Trail]
								  
						
FROM [Operadores].[Incidencias] IncidenciasTabla
WHERE IncidenciasTabla.Eliminado = 1 AND (@busqueda = '' OR IncidenciasTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
				OR CAST(IncidenciasTabla.Puntos AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' )

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Incidencias WHERE incidencias.Eliminado = 1 AND (@busqueda = '' OR Incidencias.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' OR Incidencias.Puntos LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' ))AS TotalRows,
			(	
				SELECT * FROM IncidenciaTmp	
				ORDER BY IncidenciaTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
end
GO
