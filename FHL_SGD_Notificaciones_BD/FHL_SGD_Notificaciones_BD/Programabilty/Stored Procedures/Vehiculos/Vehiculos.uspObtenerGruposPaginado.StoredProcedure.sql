USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerGruposPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero de 2024
-- Description:	Obtiene la información del catálogo de Grupos activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Vehiculos].[uspObtenerGruposPaginado] 
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
			SET @pageSize = (SELECT MAX(Id) FROM Grupos);
		END;

	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH TablaTemp AS(
                SELECT GrupoTabla.[Id]
                    ,GrupoTabla.[Nombre]
                    ,GrupoTabla.[Usuario]
                    ,GrupoTabla.[Eliminado]
                    ,GrupoTabla.[FechaCreacion]
                    ,GrupoTabla.[Trail]

                FROM  [Vehiculos].[Grupos] GrupoTabla

                WHERE GrupoTabla.Eliminado = 1 AND (@busqueda = '' OR GrupoTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
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
