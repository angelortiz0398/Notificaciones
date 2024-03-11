USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerRangoPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Rangos de operación activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Clientes].[uspObtenerRangoPaginado]
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
			SET @pageSize = (SELECT MAX(Id) FROM RangosOperaciones);
		END;

	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH TablaTemp AS(
                SELECT RangosOperacionesTabla.[Id]
                    ,RangosOperacionesTabla.[Nombre]
					,RangosOperacionesTabla.[EstadoId]
					,RangosOperacionesTabla.[MunicipioId]
					,RangosOperacionesTabla.[RangoCodigoPostal]
                    ,RangosOperacionesTabla.[Usuario]
                    ,RangosOperacionesTabla.[Eliminado]
                    ,RangosOperacionesTabla.[FechaCreacion]
                    ,RangosOperacionesTabla.[Trail]

                FROM  [Clientes].[RangosOperaciones] RangosOperacionesTabla
                WHERE RangosOperacionesTabla.Eliminado = 1 AND (@busqueda = '' OR RangosOperacionesTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
						OR RangosOperacionesTabla.RangoCodigoPostal LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 

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
