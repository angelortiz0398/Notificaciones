USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerCasetasPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los registros de dispersion en el modúlo de despacho
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerCasetasPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	--Obtiene la información de los registros de dispersiones y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT CasetasTabla.[Id]
					,CasetasTabla.[FechaHora]
					,CasetasTabla.[VehiculoId]
                    ,CasetasTabla.[DespachoId]
					,CasetasTabla.[Estacion]
					,CasetasTabla.[Referencia]
					,CasetasTabla.[MonedaIdMonto]
					,CasetasTabla.[Monto]
                    ,CasetasTabla.[Usuario]
                    ,CasetasTabla.[Eliminado]
                    ,CasetasTabla.[FechaCreacion]
                    ,CasetasTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Visor.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Despacho
                    ,JSON_QUERY((SELECT Vehiculo.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculo

                FROM [Despachos].[Casetas] CasetasTabla
                        LEFT JOIN Despachos.Visores Visor ON Visor.ManifiestoId = CasetasTabla.DespachoId
						LEFT JOIN Vehiculos.Vehiculos Vehiculo ON Vehiculo.Id = CasetasTabla.VehiculoId

				--Filtros de busqueda
                WHERE CasetasTabla.Eliminado = 1 AND (@busqueda = '' 
					OR CasetasTabla.Monto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR CasetasTabla.Estacion LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Visor.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Vehiculo.Economico LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
    )
				

	-- Obtiene la información de los registros dispersiones y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
