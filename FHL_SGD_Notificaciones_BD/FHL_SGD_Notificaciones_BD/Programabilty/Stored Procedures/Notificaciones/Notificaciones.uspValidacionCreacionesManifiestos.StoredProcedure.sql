USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionCreacionesManifiestos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Erick Dominguez
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionCreacionesManifiestos]

		@Intervalo TIME -- Parametro para recibir el intervalo de tiempo
AS
BEGIN
    SET NOCOUNT ON;
		DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
		DECLARE @FechaFin DATETIME = DATEADD(HOUR, 6,GETDATE());
		DECLARE @GastosEnIntervalo BIT;
		DECLARE @RegistrosDispersionJson NVARCHAR(MAX);
		DECLARE @Informacion Nvarchar(MAX);

    -- Verificar si se han creado Solicitudes de combustible
    IF EXISTS (
        SELECT 1 
        FROM Combustibles.SolicitudesCombustibles Solicitudes
		WHERE (Solicitudes.FechaCreacion BETWEEN @FechaInicio AND @FechaFin) AND Solicitudes.Eliminado = 1
    )
    BEGIN
        SET @GastosEnIntervalo = 1; --Enviaremos un verdadero

        -- Obtener datos de los registros para crear un mensaje personalizado
		select @Informacion = CONCAT('Se han creado solicitudes de combustible para los siguientes manifiestos:  ', STRING_AGG(Despacho.FolioDespacho,', '))
		 FROM Combustibles.SolicitudesCombustibles Solicitudes
		 LEFT JOIN Despachos.Despachos Despacho ON Despacho.Id = Solicitudes.Id
		WHERE (Solicitudes.FechaCreacion BETWEEN @FechaInicio AND @FechaFin) AND Solicitudes.Eliminado = 1
    END
    ELSE
    BEGIN
        SET @GastosEnIntervalo = 0;
    END

    SELECT 
        Resultado = @GastosEnIntervalo,
        ListaContactos = N'[{"emails":[],"phones":[],"users":[]}]',
		InformacionAdicional = @Informacion;
END
GO
