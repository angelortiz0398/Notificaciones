USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspObtenerSolicitudCombustiblePaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Solicitudes Combustibles activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Combustibles].[uspObtenerSolicitudCombustiblePaginado]
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
			SET @pageSize = (SELECT MAX(Id) FROM SolicitudesCombustibles);
		END;			


	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH TablaTmp AS(
                SELECT SolicitudCombustibleTabla.[Id]
                    ,SolicitudCombustibleTabla.[VehiculosId]
                    ,SolicitudCombustibleTabla.[ManifiestosId]
                    ,SolicitudCombustibleTabla.[KmRuta]
                    ,SolicitudCombustibleTabla.[Proyeccion]
                    ,SolicitudCombustibleTabla.[EstatusManifiestoId]
                    ,SolicitudCombustibleTabla.[EstatusSolicitud]
                    ,SolicitudCombustibleTabla.[Usuario]
                    ,SolicitudCombustibleTabla.[Eliminado]
                    ,SolicitudCombustibleTabla.[FechaCreacion]
                    ,SolicitudCombustibleTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Despacho.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Manifiestos
					,JSON_QUERY((SELECT Vehiculo.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculos

                FROM  [Combustibles].[SolicitudesCombustibles] SolicitudCombustibleTabla
                        LEFT JOIN Despachos.Despachos Despacho ON Despacho.Id = SolicitudCombustibleTabla.ManifiestosId 
						LEFT JOIN Vehiculos.Vehiculos Vehiculo ON Vehiculo.Id = SolicitudCombustibleTabla.VehiculosId
						            
					
                WHERE SolicitudCombustibleTabla.Eliminado = 1 AND (@busqueda = ''
					OR(Despacho.FolioDespacho LIKE '%'+@busqueda+'%')
					OR (Vehiculo.Economico LIKE '%'+@busqueda+'%'))
    )

	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM TablaTmp ) AS TotalRows,
			(
				SELECT * FROM TablaTmp
				ORDER BY TablaTmp.Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
