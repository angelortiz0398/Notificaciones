USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTipoGastosPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los tipos de gastos en el modúlo de despacho
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerTipoGastosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	--Obtiene la información de los registros de dispersiones y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT TipoGastosTabla.[Id]
					,TipoGastosTabla.[Nombre]
					,TipoGastosTabla.[SATID]
                    ,TipoGastosTabla.[Axapta]
					,TipoGastosTabla.[CuentaContable]
					,TipoGastosTabla.[MonedaIdMontoMaximo]
					,TipoGastosTabla.[MontoMaximo]
					,TipoGastosTabla.[ColaboradorAutorizadoId]
                    ,TipoGastosTabla.[Usuario]
                    ,TipoGastosTabla.[Eliminado]
                    ,TipoGastosTabla.[FechaCreacion]
                    ,TipoGastosTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Colaborador.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ColaboradorAutorizado

                FROM [Despachos].[TipoGastos] TipoGastosTabla
                        LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = TipoGastosTabla.ColaboradorAutorizadoId

				--Filtros de busqueda
                WHERE TipoGastosTabla.Eliminado = 1 AND (@busqueda is null 
					OR TipoGastosTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR TipoGastosTabla.SATID LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR TipoGastosTabla.Axapta LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR TipoGastosTabla.CuentaContable LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Colaborador.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
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
