USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionAsignacionesDispersionConMontosExcedidos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Erick Dominguez
-- Create date: Febrero 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionAsignacionesDispersionConMontosExcedidos]   
		@Intervalo TIME -- Parametro para recibir el intervalo de tiempo
AS
BEGIN
    SET NOCOUNT ON;
		DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
		DECLARE @FechaFin DATETIME = DATEADD(HOUR, 6,GETDATE());
		DECLARE @GastosEnIntervalo BIT;
		DECLARE @RegistrosDispersionJson NVARCHAR(MAX);
		DECLARE @Informacion Nvarchar(MAX);

    -- Verificar si se han creado Registros Dispersion con un monto superior a su monto máximo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.RegistrosDispersiones RegistroDispersion
		LEFT JOIN Despachos.TipoGastos TipoGasto ON TipoGasto.Id = RegistroDispersion.TipoGastoId
        WHERE (RegistroDispersion.FechaCreacion BETWEEN @FechaInicio AND @FechaFin) AND (RegistroDispersion.Monto > TipoGasto.MontoMaximo)
				AND (RegistroDispersion.Eliminado = 1)
    )
    BEGIN
        SET @GastosEnIntervalo = 1; --Enviaremos un verdadero

        -- Obtener datos de los registros para crear un mensaje personalizado
		select @Informacion = CONCAT('Los Registros con el manifiesto ', STRING_AGG(Despacho.FolioDespacho,', '), ' y el tipo de gasto ', STRING_AGG(TipoGasto.Nombre,', '), ' Superan el monto máximo del tipo de gasto')
		FROM Despachos.RegistrosDispersiones RegistroDispersion
		LEFT JOIN Despachos.TipoGastos TipoGasto ON TipoGasto.Id = RegistroDispersion.TipoGastoId
		LEFT JOIN Despachos.Despachos Despacho ON Despacho.Id = RegistroDispersion.DespachoId
		where (RegistroDispersion.FechaCreacion BETWEEN @FechaInicio AND @FechaFin) AND (RegistroDispersion.Monto > TipoGasto.MontoMaximo)
				AND (RegistroDispersion.Eliminado = 1)
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
