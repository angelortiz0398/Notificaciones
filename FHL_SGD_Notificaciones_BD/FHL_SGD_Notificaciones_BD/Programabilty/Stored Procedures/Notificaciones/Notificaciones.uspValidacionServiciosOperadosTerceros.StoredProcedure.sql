USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionServiciosOperadosTerceros]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionServiciosOperadosTerceros]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE());
    --DECLARE @FechaFin DATETIME = DATEADD(SECOND, DATEDIFF(SECOND, 0, @Intervalo), @FechaInicio);
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = GETDATE();
    DECLARE @VehiculosTercerosEnIntervalo BIT;
    DECLARE @VehiculosTercerosJson NVARCHAR(MAX)= N'[{"emails":[],"phones":[],"users":[]}]';

    -- Verificar si hay un Vehiculo tercero asignado a un manifiesto en el intervalo
    IF EXISTS (
        SELECT 1 
		FROM [Vehiculos].[Vehiculos] Vehiculos
		LEFT JOIN  Vehiculos.Tipos Tipos ON Tipos.Id = Vehiculos.TipoId
		WHERE Vehiculos.Eliminado = 1
		AND EXISTS (
			SELECT 1
			FROM Despachos.Despachos Despachos
			WHERE Despachos.VehiculoId = Vehiculos.Id -- Relaciona entre los Vehiculos y el vehiculo asignado al manifiesto
			AND (Despachos.EstatusId <> 2 OR Despachos.EstatusId <> 3) -- El estatus 2 y 3, significa que el manifiesto esta confirmado, o en proceso por lo que no puede utilizarse un vehiculo que esta actualmente en un manifiesto en curso
			AND Despachos.Eliminado = 1 -- Obliga a todos aquellos manifiestos que no han sido eliminados
			AND Despachos.FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Que haya sido creado entre el intervalo
			AND Tipos.Nombre LIKE '%Vehículo de terceros%' -- Que el tipo del vehiculo sea de Vehiculo de tercero, es decir foraneo
		)
    )
    BEGIN
        SET @VehiculosTercerosEnIntervalo = 1;                
    END
	ELSE
	BEGIN
		SET @VehiculosTercerosEnIntervalo = 0;
	END
    SELECT 
        Resultado = @VehiculosTercerosEnIntervalo,
        ListaContactos = @VehiculosTercerosJson,
		InformacionAdicional = N'';
END
GO
