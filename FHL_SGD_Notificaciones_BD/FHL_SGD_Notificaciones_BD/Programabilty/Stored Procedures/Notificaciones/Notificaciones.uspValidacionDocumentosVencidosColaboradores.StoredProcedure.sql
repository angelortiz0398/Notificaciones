USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionDocumentosVencidosColaboradores]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionDocumentosVencidosColaboradores]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	Declare @FechaDeHoy Datetime = getdate();
	Declare @FechaVencer datetime = Dateadd(DAY,1,@FechaDeHoy)
    DECLARE @DocumentosVencimientoEnIntervalo BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    -- Verificar si hay infracciones en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Operadores.DocumentosColaboradores 
        WHERE FechaVencimiento BETWEEN @FechaDeHoy AND @FechaVencer
    )
    BEGIN
        SET @DocumentosVencimientoEnIntervalo = 1;

        -- Obtener datos de colaboradores con infracciones en el intervalo
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.DocumentosColaboradores
                        WHERE FechaVencimiento BETWEEN @FechaDeHoy AND @FechaVencer
                    )
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.DocumentosColaboradores
                        WHERE FechaVencimiento BETWEEN @FechaDeHoy AND @FechaVencer
                    )
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.DocumentosColaboradores
                        WHERE FechaVencimiento BETWEEN @FechaDeHoy AND @FechaVencer
                    )
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @DocumentosVencimientoEnIntervalo = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @DocumentosVencimientoEnIntervalo,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
