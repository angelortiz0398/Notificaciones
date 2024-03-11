USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspObtenerEstacionesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Solicitudes de combustibles activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Combustibles].[uspObtenerEstacionesPaginado]
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
			SET @pageSize = (SELECT MAX(Id) FROM Estaciones);
		END;

	--Obtiene la información de las registros
    ;WITH TablaTemp AS(
                SELECT EstacionesTabla.[Id]
                    ,EstacionesTabla.[Nombre]
					,EstacionesTabla.[Coordenadas]
                    ,EstacionesTabla.[Usuario]
                    ,EstacionesTabla.[Eliminado]
                    ,EstacionesTabla.[FechaCreacion]
                    ,EstacionesTabla.[Trail]

                FROM  [Combustibles].[Estaciones] EstacionesTabla
                WHERE EstacionesTabla.Eliminado = 1 AND (@busqueda = '' OR EstacionesTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 
    )
	-- Obtiene la información de los registros y la convierte en un formato JSON
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
