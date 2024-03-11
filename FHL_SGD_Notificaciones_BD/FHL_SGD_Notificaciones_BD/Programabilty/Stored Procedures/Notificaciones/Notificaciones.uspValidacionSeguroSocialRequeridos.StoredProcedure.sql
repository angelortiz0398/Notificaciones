USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionSeguroSocialRequeridos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionSeguroSocialRequeridos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = GETDATE();
    DECLARE @SeguroSocualEnIntervalo BIT;
    DECLARE @TicketsJson NVARCHAR(MAX) =  N'[{"emails":[],"phones":[],"users":[]}]';


    -- Verificar si hay un ticket que pida seguro en el intervalo
    IF EXISTS (
        SELECT 1 
		FROM [Despachos].[Tickets] Tickets
		WHERE Tickets.Eliminado = 1 -- Todos los tickets que no fueran eliminados
		AND Tickets.Seguro = 1 -- Delimita a solo los tickets que vayan a ocupar seguro social
		AND Tickets.FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Que haya sido creado entre el intervalo
    )
    BEGIN
        SET @SeguroSocualEnIntervalo = 1;                
    END
	ELSE
	BEGIN
		SET @SeguroSocualEnIntervalo = 0;
	END
    SELECT 
        Resultado = @SeguroSocualEnIntervalo,
        ListaContactos = @TicketsJson,
		InformacionAdicional = N'';
END
GO
