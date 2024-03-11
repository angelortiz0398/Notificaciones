USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerRegistrosDispersionesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los registros de dispersion en el modúlo de despacho
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerRegistrosDispersionesPaginado]
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
                SELECT RegistrosDispersionesTabla.[Id]
                    ,RegistrosDispersionesTabla.[DespachoId]
                    ,RegistrosDispersionesTabla.[ColaboradorId]
					,RegistrosDispersionesTabla.[MonedaIdMonto]
                    ,RegistrosDispersionesTabla.[Monto]
                    ,RegistrosDispersionesTabla.[TipoGastoId]
                    ,RegistrosDispersionesTabla.[MetodoId]
                    ,RegistrosDispersionesTabla.[GastoOperativoId]
                    ,RegistrosDispersionesTabla.[ColaboradorAutorizadoId]
                    ,RegistrosDispersionesTabla.[Usuario]
                    ,RegistrosDispersionesTabla.[Eliminado]
                    ,RegistrosDispersionesTabla.[FechaCreacion]
                    ,RegistrosDispersionesTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Visores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Despacho
                    ,JSON_QUERY((SELECT Colaborador.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador
                    ,JSON_QUERY((SELECT TipoGasto.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoGasto
                    ,JSON_QUERY((SELECT ColaboradorAutorizado.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ColaboradorAutorizado

                FROM [Despachos].[RegistrosDispersiones] RegistrosDispersionesTabla
                        LEFT JOIN Despachos.Visores Visores ON Visores.ManifiestoId = RegistrosDispersionesTabla.DespachoId
                        LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = RegistrosDispersionesTabla.ColaboradorId
                        LEFT JOIN Despachos.TipoGastos TipoGasto ON TipoGasto.Id = RegistrosDispersionesTabla.TipoGastoId
                        LEFT JOIN Operadores.Colaboradores ColaboradorAutorizado ON ColaboradorAutorizado.Id = RegistrosDispersionesTabla.ColaboradorAutorizadoId

				--Filtros de busqueda
                WHERE RegistrosDispersionesTabla.Eliminado = 1 AND (@busqueda = '' 
					OR RegistrosDispersionesTabla.Monto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Visores.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Colaborador.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR TipoGasto.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR ColaboradorAutorizado.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
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
