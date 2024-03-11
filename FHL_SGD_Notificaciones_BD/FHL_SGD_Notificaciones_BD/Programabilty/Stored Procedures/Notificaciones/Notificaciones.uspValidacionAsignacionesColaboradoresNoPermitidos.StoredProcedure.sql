USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionAsignacionesColaboradoresNoPermitidos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionAsignacionesColaboradoresNoPermitidos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE());
    --DECLARE @FechaFin DATETIME = DATEADD(SECOND, DATEDIFF(SECOND, 0, @Intervalo), @FechaInicio);
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = GETDATE();
    DECLARE @NoPermitidosEnIntervalo BIT;
    DECLARE @NoPermitidosJson NVARCHAR(MAX)= N'[{"emails":[],"phones":[],"users":[]}]';

    -- Verificar si hay un Vehiculo tercero asignado a un manifiesto en el intervalo
	IF EXISTS (
		SELECT 1
		FROM (
			SELECT OperadorId
			FROM [Despachos].[Despachos] Despachos
			WHERE Despachos.Eliminado = 1 -- Trae aquellos despachos que no han sido eliminados
			AND (Despachos.EstatusId <> 2 OR Despachos.EstatusId <> 3) -- Trae solo los despachos que estan confirmados o en proceso de despacho
			AND Despachos.FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Trae los despachos creados entre estas fechas
			GROUP BY OperadorId 
			HAVING COUNT(*) > 1 -- Cuenta cuantos registros y si hay alguno repetido cuyo OperadorId sea el mismo
		) AS OperadoresNoPermitidos
	)
    BEGIN
        SET @NoPermitidosEnIntervalo = 1;                
    END
	ELSE
	BEGIN
		SET @NoPermitidosEnIntervalo = 0;
	END
    SELECT 
        Resultado = @NoPermitidosEnIntervalo,
        ListaContactos = @NoPermitidosJson,
		InformacionAdicional = N'';
END
GO
