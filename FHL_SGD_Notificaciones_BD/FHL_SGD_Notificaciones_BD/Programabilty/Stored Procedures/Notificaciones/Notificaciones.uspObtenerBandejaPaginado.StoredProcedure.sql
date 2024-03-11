USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerBandejaPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de las notifiaciones en la bandeja en el modúlo de notificaciones
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspObtenerBandejaPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)='',
	@fechaInicial      datetime = NULL,
	@fechaFinal        datetime = NULL,
	@usuarioId         bigint = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

	--Obtiene la información de los registros de dispersiones y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT BandejasTabla.[Id]
					,BandejasTabla.[ColaboradoresId]
					,BandejasTabla.[AlertasId]
                    ,BandejasTabla.[FechaLlegada]
					,BandejasTabla.[FechaCreacionAlerta]
					,BandejasTabla.[Lectura]
                    ,BandejasTabla.[Usuario]
                    ,BandejasTabla.[Eliminado]
                    ,BandejasTabla.[FechaCreacion]
                    ,BandejasTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    --,JSON_QUERY((SELECT Colaborador.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaboradores
                    ,JSON_QUERY((SELECT Alerta.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Alertas

                FROM [Notificaciones].[Bandejas] BandejasTabla
                        --LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = BandejasTabla.ColaboradoresId
						LEFT JOIN Notificaciones.Alertas Alerta ON Alerta.Id = BandejasTabla.AlertasId

				--Filtros de busqueda
                WHERE BandejasTabla.Eliminado = 1 AND BandejasTabla.FechaLlegada >= @fechaInicial AND BandejasTabla.FechaLlegada <= @fechaFinal
					AND BandejasTabla.ColaboradoresId = @usuarioId
					AND (@busqueda = '' 					
					--OR Colaborador.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					OR Alerta.TextoAlerta LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
					)
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
