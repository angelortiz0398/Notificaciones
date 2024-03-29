USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionTarifasProximasAVencer]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Valentin Baltazar>
-- Create date: <29-02-2024>
-- Description:	<Procedimiento para obtener las tarifas proximas a vencer>
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionTarifasProximasAVencer]
 @Intervalo time = '23:59:59.9999999'

AS
BEGIN
	Declare @Tiempo int = 30
	Declare @FechaDeHoy Datetime = getdate();
	Declare @FechaVencer datetime = Dateadd(DAY,@Tiempo,@FechaDeHoy)
	Declare @TarifasJson NVARCHAR(MAX);
	DEclare @EsVerdadero bit
	Declare @Informacion Nvarchar(MAX)
	
		
	set @EsVerdadero = 1;
	SET @TarifasJson = N'[{"emails":[],"phones":[],"users":[]}]';
	select @Informacion = CONCAT('Los Clientes ', STRING_AGG(clientes.RazonSocial,', '), ' Tienen tarifas proximas a vencer')
	   from Clientes.Tarifas tarifas 
inner join Clientes.Clientes clientes on clientes.Id = tarifas.ClienteId
where tarifas.FechaVigenciaFinal > @FechaDeHoy and tarifas.FechaVigenciaFinal <@FechaVencer;

select 
Resultado = @EsVerdadero,
ListaContactos = @TarifasJson,
InformacionAdicional = @Informacion;

END

GO
