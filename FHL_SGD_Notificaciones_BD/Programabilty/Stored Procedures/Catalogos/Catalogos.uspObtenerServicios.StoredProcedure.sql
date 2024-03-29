USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Catalogos].[uspObtenerServicios]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Custodias activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Catalogos].[uspObtenerServicios] 
	@Id				bigint = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Obtiene la información de los registros y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT [Id]
					  ,[Nombre]
					  ,[Descripcion]
					  ,[Trail]
					  ,[FechaCreacion]
					  ,[Eliminado]

                FROM  [Catalogos].[Servicios] Servicios

                WHERE Servicios.Eliminado = 1 AND (@Id is null OR Servicios.Id = @Id)
    )
	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			--(SELECT COUNT(*) FROM Custodias WHERE Custodias.Eliminado = 1 AND (@busqueda = '' OR Custodias.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
				FOR JSON PATH
			) AS JsonSalida;
END
GO
