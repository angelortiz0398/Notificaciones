USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionDiasInactividad]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionDiasInactividad]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	Declare @TiempoRestar int = 2;
    DECLARE @FechaFin DATETIME = GETDATE();
	DECLARE @FechaInicio DATETIME = DATEADD(DAY, @TiempoRestar, @FechaFin);
    DECLARE @ColaboradoresSinManifiesto BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);
	DECLARE @a int = (SELECT Count(Id)
        FROM Operadores.Colaboradores
        WHERE Id NOT IN (
            SELECT DISTINCT OperadorId
            FROM Despachos.Despachos
            WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
        ));

    -- Verificar si hay infracciones en el intervalo
    IF EXISTS (
        SELECT 1
        FROM Operadores.Colaboradores
        WHERE Id NOT IN (
            SELECT DISTINCT OperadorId
            FROM Despachos.Despachos
            WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
        )
    )
    BEGIN
        SET @ColaboradoresSinManifiesto = 1;

        -- Obtener datos de colaboradores con infracciones en el intervalo
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
                    FROM Operadores.Colaboradores
                    WHERE Id NOT IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
                    FROM Operadores.Colaboradores
                    WHERE Id NOT IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id NOT IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Despachos
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
		PRINT @a;
    END
    ELSE
    BEGIN
        SET @ColaboradoresSinManifiesto = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresSinManifiesto,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
