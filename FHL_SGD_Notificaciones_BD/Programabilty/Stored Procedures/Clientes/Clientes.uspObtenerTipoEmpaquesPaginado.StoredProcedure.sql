USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerTipoEmpaquesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de TiposEmpaques activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Clientes].[uspObtenerTipoEmpaquesPaginado] 
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM Custodias);
		END;

	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH TablaTemp AS(
                SELECT TipoEmpaqueTabla.[Id]
                    ,TipoEmpaqueTabla.[Nombre]
					,TipoEmpaqueTabla.[Volumen]
					,TipoEmpaqueTabla.[UnidadMedidaId]
                    ,TipoEmpaqueTabla.[Usuario]
                    ,TipoEmpaqueTabla.[Eliminado]
                    ,TipoEmpaqueTabla.[FechaCreacion]
                    ,TipoEmpaqueTabla.[Trail]

					--Tablas relacionadas
					,JSON_QUERY((SELECT UnidadesMedidas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS UnidadMedida

                FROM  [Clientes].[TiposEmpaques] TipoEmpaqueTabla
				INNER JOIN Productos.UnidadesMedidas UnidadesMedidas ON UnidadesMedidas.Id = TipoEmpaqueTabla.UnidadMedidaId

                WHERE TipoEmpaqueTabla.Eliminado = 1 AND (@busqueda = '' 
						OR TipoEmpaqueTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
						OR CAST(TipoEmpaqueTabla.Volumen AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
						OR UnidadesMedidas.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 

    )
	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM TablaTemp) AS TotalRows,
			(
				SELECT * FROM TablaTemp
				ORDER BY TablaTemp.Id ASC
								OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
