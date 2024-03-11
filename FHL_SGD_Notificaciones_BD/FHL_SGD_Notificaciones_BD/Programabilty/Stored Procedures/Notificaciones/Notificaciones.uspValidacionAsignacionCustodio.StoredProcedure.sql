USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionAsignacionCustodio]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Febrero 2024
-- Description:	Recuperacion de datos para envío de notificaciones cada
--				que se agregue un nuevo custodio
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionAsignacionCustodio]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE());
    --DECLARE @FechaFin DATETIME = DATEADD(SECOND, DATEDIFF(SECOND, 0, @Intervalo), @FechaInicio);
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = DATEADD(HOUR,6,GETDATE());
    DECLARE @CustodiosEnIntervalo BIT;
    DECLARE @CustodiosJson NVARCHAR(MAX) = N'[{"emails":[],"phones":[],"users":[]}]';
	
    -- Verificar si hay un custodio nuevo en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.Custodias 
        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
    )
    BEGIN
        SET @CustodiosEnIntervalo = 1;
        -- Obtener datos de Custodios en el intervalo                    
        --SET @CustodiosJson = (SELECT Custodio.Id FROM Despachos.Custodias Custodio where ((Custodio.FechaCreacion BETWEEN @FechaFin AND @FechaFin) AND (Custodio.Eliminado = 1) ));
    END
	ELSE
	BEGIN
	SET @CustodiosEnIntervalo = 0;
	--SET @CustodiosJson = N'[{"emails":[],"phones":[],"users":[]}]';
	END
    SELECT 
        Resultado = @CustodiosEnIntervalo,
        ListaContactos = @CustodiosJson,
		InformacionAdicional = N'';
END
GO
