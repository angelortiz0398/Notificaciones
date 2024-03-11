USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionAsignacionesManifiestos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionAsignacionesManifiestos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;

    --DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEPART(SECOND, GETDATE()), GETDATE());
    --DECLARE @FechaFin DATETIME = DATEADD(SECOND, DATEDIFF(SECOND, 0, @Intervalo), @FechaInicio);
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = GETDATE();
    DECLARE @ColaboradoresEnManifiesto BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    -- Verificar si hay infracciones en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.Despachos 
        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
    )
    BEGIN
        SET @ColaboradoresEnManifiesto = 1;

        -- Obtener datos de colaboradores con infracciones en el intervalo
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @ColaboradoresEnManifiesto = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresEnManifiesto,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
