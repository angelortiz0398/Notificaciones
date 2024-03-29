USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionDocumentosAVencerVehiculos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Marzo 2024
-- Description:	Validación para verificar si hay un Documento por vencer
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionDocumentosAVencerVehiculos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	
	Declare @FechaDeHoy Datetime = getdate();
	Declare @FechaVencer datetime = Dateadd(HOUR,6,@FechaDeHoy)
    DECLARE @DocumentosVencimientoEnIntervalo BIT;
    DECLARE @DocumentoJson NVARCHAR(MAX) =  N'[{"emails":[],"phones":[],"users":[]}]';

    -- Verificar si hay Documentos a vencer en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Vehiculos.Documentos 
        WHERE FechaVencimiento BETWEEN @FechaDeHoy AND @FechaVencer
    )
    BEGIN
        SET @DocumentosVencimientoEnIntervalo = 1;		     
    END
    ELSE
    BEGIN
        SET @DocumentosVencimientoEnIntervalo = 0;
       -- SET @DocumentoJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @DocumentosVencimientoEnIntervalo,
        ListaContactos = @DocumentoJson,
		InformacionAdicional = N'';
END
GO
