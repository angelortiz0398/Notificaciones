USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionInfraccionesRegistradas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Febrero 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionInfraccionesRegistradas]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @FechaFin DATETIME = DATEADD(HOUR, 6,GETDATE())
    DECLARE @InfraccionesEnIntervalo BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX) = N'[{"emails":[],"phones":[],"users":[]}]';
	DECLARE @InformacionAdicional NVARCHAR(MAX) = N'';

    -- Verificar si hay infracciones en el intervalo
    IF EXISTS (
        SELECT 1 
        FROM Operadores.InfraccionesColaboradores 
        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
    )
    BEGIN
        SET @InfraccionesEnIntervalo = 1;

        -- Obtener datos de colaboradores con infracciones en el intervalo
        SET @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.InfraccionesColaboradores
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.InfraccionesColaboradores
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradoresId
                        FROM Operadores.InfraccionesColaboradores
                        WHERE FechaCreacion BETWEEN @FechaInicio AND @FechaFin
                    )
                    FOR JSON PATH
                )
            FOR JSON PATH
        );

		--SET @InformacionAdicional = (SELECT 
		--		CONCAT('El colaborador ', ColaboradoresConInfracciones.Nombres, ' tiene una infraccion por el monto de ', InfraccionesConMontos.Montos, '. ')
		--	FROM
		--		(
		--			SELECT 
		--				STRING_AGG(Colaboradores.Nombre, ', ') AS Nombres
		--			FROM 
		--				Operadores.Colaboradores
		--				INNER JOIN Operadores.InfraccionesColaboradores InfraccionesColaboradores ON InfraccionesColaboradores.ColaboradoresId = Colaboradores.Id
		--			WHERE 
		--				InfraccionesColaboradores.FechaCreacion BETWEEN @FechaInicio AND @FechaFin
		--		) AS ColaboradoresConInfracciones,
		--		(
		--			SELECT 
		--				STRING_AGG(InfraccionesColaboradores.Monto, ', ') AS Montos
		--			FROM 
		--				Operadores.InfraccionesColaboradores
		--			WHERE 
		--				FechaCreacion BETWEEN @FechaInicio AND @FechaFin
		--		) AS InfraccionesConMontos);
    END
    ELSE
    BEGIN
        SET @InfraccionesEnIntervalo = 0;
        SET @ColaboradoresJson = @ColaboradoresJson;
		SET @InformacionAdicional = N'';
    END

    SELECT 
        Resultado = @InfraccionesEnIntervalo,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = @InformacionAdicional;
END
GO
