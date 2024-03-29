USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionManifiestosAbiertosExcedidos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Angel Ortiz
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionManifiestosAbiertosExcedidos]
    @Intervalo TIME
AS
BEGIN
    SET NOCOUNT ON;
	--DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
    DECLARE @ColaboradoresManifiestosAbiertosExcedidos BIT;
    DECLARE @ColaboradoresJson NVARCHAR(MAX);

    IF EXISTS (
        SELECT 1
        FROM Operadores.Colaboradores
        WHERE Id IN (
			SELECT Colaboradores.Id
			FROM Operadores.Colaboradores AS Colaboradores
			INNER JOIN (
				SELECT Despachos.OperadorId, COUNT(*) AS DespachosCount
				FROM Despachos.Despachos AS Despachos
				WHERE Despachos.EstatusId IN (2, 3) AND Despachos.Eliminado = 1
				GROUP BY Despachos.OperadorId
				HAVING COUNT(*) > 2
			) AS Temp ON Colaboradores.Id = Temp.OperadorId
        )
    )
    BEGIN
        SET @ColaboradoresManifiestosAbiertosExcedidos = 1;
        SELECT @ColaboradoresJson = (
            SELECT
                emails = (
                    SELECT CorreoElectronico AS email
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT Colaboradores.Id
						FROM Operadores.Colaboradores AS Colaboradores
						INNER JOIN (
							SELECT Despachos.OperadorId, COUNT(*) AS DespachosCount
							FROM Despachos.Despachos AS Despachos
							WHERE Despachos.EstatusId IN (2, 3) AND Despachos.Eliminado = 1
							GROUP BY Despachos.OperadorId
							HAVING COUNT(*) > 2
						) AS Temp ON Colaboradores.Id = Temp.OperadorId
					)
                    FOR JSON PATH
                ),
                phones = (
                    SELECT Telefono AS phone
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT Colaboradores.Id
						FROM Operadores.Colaboradores AS Colaboradores
						INNER JOIN (
							SELECT Despachos.OperadorId, COUNT(*) AS DespachosCount
							FROM Despachos.Despachos AS Despachos
							WHERE Despachos.EstatusId IN (2, 3) AND Despachos.Eliminado = 1
							GROUP BY Despachos.OperadorId
							HAVING COUNT(*) > 2
						) AS Temp ON Colaboradores.Id = Temp.OperadorId
					)
                    FOR JSON PATH
                ),
                users = (
                    SELECT Id AS userId
					FROM Operadores.Colaboradores
					WHERE Id IN (
						SELECT Colaboradores.Id
						FROM Operadores.Colaboradores AS Colaboradores
						INNER JOIN (
							SELECT Despachos.OperadorId, COUNT(*) AS DespachosCount
							FROM Despachos.Despachos AS Despachos
							WHERE Despachos.EstatusId IN (2, 3) AND Despachos.Eliminado = 1
							GROUP BY Despachos.OperadorId
							HAVING COUNT(*) > 2
						) AS Temp ON Colaboradores.Id = Temp.OperadorId
					)
                    FOR JSON PATH
                )
            FOR JSON PATH
        );
    END
    ELSE
    BEGIN
        SET @ColaboradoresManifiestosAbiertosExcedidos = 0;
        SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @ColaboradoresManifiestosAbiertosExcedidos,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = N'';
END
GO
