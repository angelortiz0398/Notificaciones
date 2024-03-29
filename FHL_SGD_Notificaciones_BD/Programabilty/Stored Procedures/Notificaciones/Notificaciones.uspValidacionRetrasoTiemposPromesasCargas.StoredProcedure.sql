USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionRetrasoTiemposPromesasCargas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionRetrasoTiemposPromesasCargas]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = DATEADD(HOUR, 6,GETDATE());
    DECLARE @ColaboradoresRetrasadosCarga BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    -- Verificar si hay infracciones en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.Visores 
        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Visores que esten dentro del intervalo
		AND @FechaFin > Visores.FechaCargaEstimada -- Que la fecha actual sea mayor que la fecha de carga estimada
    )
    BEGIN
        SET @ColaboradoresRetrasadosCarga = 1;

        -- Obtener datos de colaboradores con infracciones en el intervalo
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Visores
						WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Visores que esten dentro del intervalo
						AND (Estatus = 2 OR Estatus = 3) -- Aquellos que estan confirmados o en proceso
						AND @FechaFin > Visores.FechaCargaEstimada -- Que la fecha actual sea mayor que la fecha de carga estimada
                    )
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Visores
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Visores que esten dentro del intervalo
						AND (Estatus = 2 OR Estatus = 3) -- Aquellos que estan confirmados o en proceso
						AND @FechaFin > Visores.FechaCargaEstimada -- Que la fecha actual sea mayor que la fecha de carga estimada
                    )
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT OperadorId
                        FROM Despachos.Visores
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin -- Visores que esten dentro del intervalo
						AND (Estatus = 2 OR Estatus = 3) -- Aquellos que estan confirmados o en proceso
						AND @FechaFin > Visores.FechaCargaEstimada -- Que la fecha actual sea mayor que la fecha de carga estimada
                    )
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @ColaboradoresRetrasadosCarga = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresRetrasadosCarga,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
