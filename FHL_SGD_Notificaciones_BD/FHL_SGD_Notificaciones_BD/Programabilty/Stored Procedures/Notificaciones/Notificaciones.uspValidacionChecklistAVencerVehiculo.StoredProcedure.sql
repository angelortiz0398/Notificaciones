USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionChecklistAVencerVehiculo]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================
--Autor: Omar Leyva
--Fecha: Marzo 2024
-- Descripcion:Seleccionar los checklist por vehículo para conocer	
--			  el próximo a vencer
--==============================================================
CREATE PROCEDURE[Notificaciones].[uspValidacionChecklistAVencerVehiculo]
AS
BEGIN
	--Guarda la informacion de checklist por vehiculo
	DECLARE @ChecklistVehiculo NVARCHAR(MAX);
	DECLARE @DiaActual NVARCHAR(50) = DATENAME(dw, GETDATE());
	DECLARE @MesActual NVARCHAR(50) = DATENAME(month, GETDATE());

	SET @ChecklistVehiculo = (SELECT 
									Vehiculo.Periodicidad,Vehiculo.CheckListId,Vehiculo.VehiculoId 
							  FROM Vehiculos.Checkslist Vehiculo 
							  Where Vehiculo.Eliminado = 1 and Vehiculo.CheckListId != 0 and Vehiculo.FechaInicio < GETDATE() Order By Vehiculo.VehiculoId FOR JSON AUTO);
	PRINT(@ChecklistVehiculo)
	--Tabla temporal en donde se almacenan los Checklist asociados a un vehiculo y su periodicidad DESPUES SELECCIONARLAS POR MANIFIESTO O MESES
		CREATE TABLE #PERIODICIDAD(
									Periodicidad NVARCHAR(MAX)NULL,
									VehiculoId bigint  NULL,
									CheckListId bigint  NULL,
									Manifiesto int NULL,
									CoincideMes int NULL,
									CoincideDia int NULL
								  );
	INSERT INTO #PERIODICIDAD (Periodicidad, VehiculoId, CheckListId, Manifiesto, CoincideMes, CoincideDia)
    SELECT 
        Vehiculo.Periodicidad,
        Vehiculo.VehiculoId,
        Vehiculo.CheckListId,
        CASE WHEN Vehiculo.Periodicidad LIKE '%"Manifiesto"%' THEN 1 ELSE 0 END AS Manifiesto,
        CASE WHEN @MesActual IN (SELECT value FROM OPENJSON(Vehiculo.Periodicidad, '$.Periodicidad.meses')) THEN 1 ELSE 0 END AS CoincideMes,
        CASE WHEN @DiaActual IN (SELECT value FROM OPENJSON(Vehiculo.Periodicidad, '$.Periodicidad.dias')) THEN 1 ELSE 0 END AS CoincideDia
    FROM OPENJSON(@ChecklistVehiculo)
    WITH (
        Periodicidad NVARCHAR(MAX) '$.Periodicidad',
        VehiculoId bigint '$.VehiculoId',
        CheckListId bigint '$.CheckListId'
    ) AS Vehiculo
	SELECT * FROM #PERIODICIDAD
	DROP TABLE #PERIODICIDAD;
	--EXEC [Notificaciones].[uspValidacionChecklistAVencerVehiculo]
	

		
END
GO
