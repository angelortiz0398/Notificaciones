USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionTicketsRecibidosSinCostos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionTicketsRecibidosSinCostos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE());
    --DECLARE @FechaFin DATETIME = DATEADD(SECOND, DATEDIFF(SECOND, 0, @Intervalo), @FechaInicio);
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = GETDATE();
    DECLARE @TicketsEnIntervalo BIT;
    DECLARE @TicketsJson NVARCHAR(MAX)= N'[{"emails":[],"phones":[],"users":[]}]';

    -- Verificar si hay un custodio nuevo en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.Tickets 
        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
		AND Eliminado = 1
		AND (SumaAsegurada = 0 OR SumaAsegurada = null) 
    )
    BEGIN
        SET @TicketsEnIntervalo = 1;
        -- Obtener datos de Tickets en el intervalo                    
    END
	ELSE
	BEGIN
		SET @TicketsEnIntervalo = 0;
	END
    SELECT 
        Resultado = @TicketsEnIntervalo,
        ListaContactos = @TicketsJson,
		InformacionAdicional = N'';
END
GO
