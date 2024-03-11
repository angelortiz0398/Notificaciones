USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerRegistrosLiquidacionesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los registros de liquidaciones en el modúlo de despacho
-- =============================================
Create PROCEDURE [Despachos].[uspObtenerRegistrosLiquidacionesPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	--Obtiene la información de los registros de liquidaciones y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT RegistrosLiquidacionesTabla.[Id]
                    ,RegistrosLiquidacionesTabla.[DespachoId]
                    ,RegistrosLiquidacionesTabla.[ColaboradorId]
					,RegistrosLiquidacionesTabla.[TipoGastoId]
					,RegistrosLiquidacionesTabla.[Deducible]
					,RegistrosLiquidacionesTabla.[MonedaIdMonto]
                    ,RegistrosLiquidacionesTabla.[Monto]
                    ,RegistrosLiquidacionesTabla.[Impuesto]
                    ,RegistrosLiquidacionesTabla.[Adjunto]
                    ,RegistrosLiquidacionesTabla.[Usuario]
                    ,RegistrosLiquidacionesTabla.[Eliminado]
                    ,RegistrosLiquidacionesTabla.[FechaCreacion]
                    ,RegistrosLiquidacionesTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Visores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Despacho
                    ,JSON_QUERY((SELECT Colaborador.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador
					,JSON_QUERY((SELECT TipoGasto.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoGasto

                FROM  Despachos.RegistrosLiquidaciones RegistrosLiquidacionesTabla
                        LEFT JOIN Despachos.Visores Visores ON Visores.ManifiestoId = RegistrosLiquidacionesTabla.DespachoId
                        LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = RegistrosLiquidacionesTabla.ColaboradorId
						LEFT JOIN Despachos.TipoGastos TipoGasto ON TipoGasto.Id = RegistrosLiquidacionesTabla.TipoGastoId

                WHERE RegistrosLiquidacionesTabla.Eliminado = 1 AND (@busqueda = '' 
					OR RegistrosLiquidacionesTabla.Monto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Visores.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Colaborador.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR TipoGasto.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
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
