USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerCedisPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerCedisPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM CentrosDistribuciones);
	END;
	--Obtener informacion de CEDIS y convertilas a json 
	;WITH CEDISTmp AS
						(
							SELECT CedisTabla.[Id]
								  ,CedisTabla.[Nombre]
								  ,CedisTabla.[Descripcion]
								  ,CedisTabla.[Geolocalizacion]
								  ,CedisTabla.[Usuario]
								  ,CedisTabla.[Eliminado]
								  ,CedisTabla.[FechaCreacion]
								  ,CedisTabla.[Trail]

FROM [Operadores].[CentrosDistribuciones] CedisTabla
WHERE CedisTabla.Eliminado = 1 AND (@busqueda = '' OR CedisTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM [Operadores].[CentrosDistribuciones] Cedis WHERE Cedis.Eliminado = 1 AND (@busqueda = '' OR Cedis.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'   ))AS TotalRows,
			(	
				SELECT * FROM CEDISTmp	
				ORDER BY CEDISTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
