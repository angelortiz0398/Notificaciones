USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspObtenerCheckpointsPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Operadores].[uspObtenerCheckpointsPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
AS
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize =0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM [CheckPoint]);
	END;
	--Obtener informacion de Incidencias y convertilas a json
	;WITH CheckPointTmp AS
						(
							SELECT CheckPointsTabla.[Id]
								  ,CheckPointsTabla.[Nombre]
								  ,CheckPointsTabla.[Geolocalizacion]
								  ,CheckPointsTabla.[Radio]
								  ,CheckPointsTabla.[TiempoMaxEspera]
								  ,CheckPointsTabla.[Usuario]
								  ,CheckPointsTabla.[Eliminado]
								  ,CheckPointsTabla.[FechaCreacion]
								  ,CheckPointsTabla.[Trail]
								  							  
						
FROM [Operadores].[CheckPoint] CheckPointsTabla
WHERE CheckPointsTabla.Eliminado = 1 AND (@busqueda = '' OR CheckPointsTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
				OR CAST(CheckPointsTabla.TiempoMaxEspera AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' )

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM [CheckPoint] WHERE [CheckPoint].Eliminado = 1 AND (@busqueda = '' OR [CheckPoint].Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' OR [CheckPoint].TiempoMaxEspera LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' ))AS TotalRows,
			(	
				SELECT * FROM CheckPointTmp	
				ORDER BY CheckPointTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
end
GO
