USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspObtenerProductosPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Productos].[uspObtenerProductosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
		Declare @UnidadMedida varchar(200);
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Productos.Productos);
			END;
		
		;WITH CteTmp AS(
			Select 
			   [Productos].[Id]
			  ,[Productos].[ClaveInterna]
			  ,[Productos].[ClaveProductoSAT]
			  ,[Productos].[ClaveUnidadSAT]
			  ,[Productos].[UnidadMedidaId]
			  ,UnidadMedida =	(
								SELECT  Nombre 
								FROM Productos.UnidadesMedidas
								WHERE Id IN (
			
										(
											(
												SELECT UnidadMedidaId
												FROM Productos.Productos Productos
												WHERE Productos.Id = ProductosPivote.Id
											)
										)
								)
							)
			  ,[Productos].[Nombre]
			  ,[Productos].[MaterialPeligroso]
			  ,[Productos].[PeligrosoId]
			  ,Peligroso = (select
							case when Productos.MaterialPeligroso = 'false'
							Then 'No'
							else 'si'
							end AS Peligroso
							from Productos.Productos Productos
							WHERE Productos.Id = ProductosPivote.Id)
			  ,[Productos].[UNId]
			  ,[Productos].[PesoUnitario]
			  ,[Productos].[EmbalajeId]
			  ,[Productos].[Trail]
			
				From Productos.[Productos] Productos
				INNER JOIN Productos.Productos ProductosPivote on Productos.Id = ProductosPivote.Id
				WHERE	Productos.Eliminado = 1 AND (@busqueda = '' OR Productos.ClaveInterna LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
																	OR Productos.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Productos.Productos WHERE Productos.Eliminado = 1 AND (@busqueda = '' OR Productos.ClaveInterna LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
																										OR Productos.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
