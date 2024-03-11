USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionGastosNoComprobadosExcedidos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Erick Dominguez
-- Create date: Marzo 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionGastosNoComprobadosExcedidos]
		@Intervalo TIME -- Parametro para recibir el intervalo de tiempo
AS
BEGIN
    SET NOCOUNT ON;
		DECLARE @GastosEnIntervalo BIT;
		DECLARE @RegistrosDispersionJson NVARCHAR(MAX);
		DECLARE @Informacion Nvarchar(MAX);

    -- Verificar si se han creado Registros Dispersion con un monto superior a su monto máximo
    IF EXISTS (
        SELECT 1 
        FROM Despachos.RegistrosDispersiones RegistroDispersion		
		LEFT JOIN Despachos.RegistrosLiquidaciones RegistroLiquidacion ON RegistroLiquidacion.DespachoId = RegistroDispersion.DespachoId AND
																			RegistroLiquidacion.TipoGastoId = RegistroDispersion.TipoGastoId
		WHERE (RegistroDispersion.Eliminado = 1)
			  AND RegistroLiquidacion.Id IS NULL -- Verificar el registro de dispersión no haya sido liquidado
    )
    BEGIN
        SET @GastosEnIntervalo = 1; --Enviaremos un verdadero

        -- Obtener datos de los registros para crear un mensaje personalizado
		select @Informacion = CONCAT('El colaborador ', STRING_AGG(Colaborador.Nombre,', '), ' ha excedido los gastos no comprobados')
		FROM Despachos.RegistrosDispersiones RegistroDispersion
		-- Tablas necesarias para la creación de la notificación
		LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = RegistroDispersion.ColaboradorId
		LEFT JOIN Despachos.RegistrosLiquidaciones RegistroLiquidacion ON RegistroLiquidacion.DespachoId = RegistroDispersion.DespachoId AND
																			RegistroLiquidacion.TipoGastoId = RegistroDispersion.TipoGastoId
		where (RegistroDispersion.Eliminado = 1)
			  AND RegistroLiquidacion.Id IS NULL -- Verificar el registro de dispersión no haya sido liquidado
    END
    ELSE
    BEGIN
        SET @GastosEnIntervalo = 0; --Enviaremos un falso
    END

    SELECT 
        Resultado = @GastosEnIntervalo,
        ListaContactos = N'[{"emails":[],"phones":[],"users":[]}]',
		InformacionAdicional = @Informacion;
END
GO
