USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerProveedoresPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los registros de dispersion en el modúlo de despacho
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerProveedoresPaginado]
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
                SELECT ProveedoresTabla.[Id]
					,ProveedoresTabla.[DespachoId]
					,ProveedoresTabla.[Nombre]
                    ,ProveedoresTabla.[RFC]
					,ProveedoresTabla.[CorreoElectronico]
					,ProveedoresTabla.[NumeroCelular]
                    ,ProveedoresTabla.[Usuario]
                    ,ProveedoresTabla.[Eliminado]
                    ,ProveedoresTabla.[FechaCreacion]
                    ,ProveedoresTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Visor.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Despacho

                FROM [Despachos].[RegistroProveedores] ProveedoresTabla
                        LEFT JOIN Despachos.Visores Visor ON Visor.ManifiestoId = ProveedoresTabla.DespachoId

				--Filtros de busqueda
                WHERE ProveedoresTabla.Eliminado = 1 AND (@busqueda = '' 
					OR ProveedoresTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR ProveedoresTabla.RFC LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR ProveedoresTabla.CorreoElectronico LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Visor.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
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
