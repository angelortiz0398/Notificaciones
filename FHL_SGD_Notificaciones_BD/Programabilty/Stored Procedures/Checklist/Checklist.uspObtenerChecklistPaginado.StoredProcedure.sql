USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Checklist].[uspObtenerChecklistPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Diciembre de 2023
-- Description:	Obtiene la información del catálogo de Checklists activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Checklist].[uspObtenerChecklistPaginado]
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
			SET @pageSize = (SELECT MAX(Id) FROM Checklist);
		END;

	--Obtiene la información de los registros y la conviernte en un formato JSON
    ;WITH TablaTemp AS(
                SELECT ChecklistTabla.[Id]
                    ,ChecklistTabla.[Nombre]
					,ChecklistTabla.[PonderacionMaxima]
					,ChecklistTabla.[FechaVencimiento]
					,ChecklistTabla.[CorreosNotificacion]
					,ChecklistTabla.[QuienEjecuta]
                    ,ChecklistTabla.[Usuario]
                    ,ChecklistTabla.[Eliminado]
                    ,ChecklistTabla.[FechaCreacion]
                    ,ChecklistTabla.[Trail]

                FROM  [Checklist].[CheckList] ChecklistTabla
                WHERE ChecklistTabla.Eliminado = 1 AND (@busqueda = '' OR ChecklistTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 

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
