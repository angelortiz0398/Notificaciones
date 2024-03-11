USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionManifiestosAbiertos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionManifiestosAbiertos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @ColaboradoresManifiestosAbiertos BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    IF EXISTS (
        SELECT 1
        FROM Operadores.Colaboradores
        WHERE Id IN (
            SELECT DISTINCT OperadorId
            FROM Despachos.Despachos
            WHERE (EstatusId = 2 OR EstatusId = 3) -- Todos aquellos despachos que estan abiertos (Los confirmados y los que estan en proceso)
			AND Eliminado = 1 -- Que no han sido eliminados
        )
    )
    BEGIN
        SET @ColaboradoresManifiestosAbiertos = 1;
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Despachos
						WHERE (EstatusId = 2 OR EstatusId = 3) -- Todos aquellos despachos que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
					)
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Despachos
						WHERE (EstatusId = 2 OR EstatusId = 3) -- Todos aquellos despachos que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
					)
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Despachos
						WHERE (EstatusId = 2 OR EstatusId = 3) -- Todos aquellos despachos que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
					)
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @ColaboradoresManifiestosAbiertos = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresManifiestosAbiertos,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
