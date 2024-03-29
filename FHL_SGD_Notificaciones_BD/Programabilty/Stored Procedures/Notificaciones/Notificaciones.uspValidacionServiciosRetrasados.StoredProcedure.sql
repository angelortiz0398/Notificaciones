USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionServiciosRetrasados]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	Compara si un manifiesto abierto (Con estatus 2 o 3) tiene un retraso con respecto a la FechaEntregaRetorno, si la fecha actual es mayor.
-- Entonces, Valida si tiene una FechaRetorno diferente de nulo y si la fecha actual es mayor que esta
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionServiciosRetrasados]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaHoraActual DATETIME = DATEADD(HOUR, 6,GETDATE());
    DECLARE @ColaboradoresServiciosRetrasados BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    IF EXISTS (
        SELECT 1
        FROM Operadores.Colaboradores
        WHERE Id IN (
            SELECT DISTINCT OperadorId
            FROM Despachos.Visores Visores
            WHERE (Estatus = 2 OR Estatus = 3) -- Todos aquellos Tickets que estan abiertos (Los confirmados y los que estan en proceso)
			AND Eliminado = 1 -- Que no han sido eliminados
			AND @FechaHoraActual > Visores.FechaPromesaRetorno -- Si la fecha y hora de este momento es mayor que la fecha promesa de retorno del ticket
        )
    )
    BEGIN
        SET @ColaboradoresServiciosRetrasados = 1;
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Visores Visores
						WHERE (Estatus = 2 OR Estatus = 3) -- Todos aquellos Tickets que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
						AND @FechaHoraActual > Visores.FechaPromesaRetorno -- Su la fecha y hora de este momento es mayor que la fecha promesa de retorno del ticket
					)
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Visores Visores
						WHERE (Estatus = 2 OR Estatus = 3) -- Todos aquellos Tickets que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
						AND @FechaHoraActual > Visores.FechaPromesaRetorno -- Su la fecha y hora de este momento es mayor que la fecha promesa de retorno del ticket
					)
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT DISTINCT OperadorId
						FROM Despachos.Visores Visores
						WHERE (Estatus = 2 OR Estatus = 3) -- Todos aquellos Tickets que estan abiertos (Los confirmados y los que estan en proceso)
						AND Eliminado = 1 -- Que no han sido eliminados
						AND @FechaHoraActual > Visores.FechaPromesaRetorno -- Su la fecha y hora de este momento es mayor que la fecha promesa de retorno del ticket
					)
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @ColaboradoresServiciosRetrasados = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresServiciosRetrasados,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
