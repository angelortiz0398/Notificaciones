USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertaVisores]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertaVisores]
@Manifiesto varchar(20),
@Operador varchar(350),
@Vehiculo Varchar(150),
@Placa varchar(50),
@Economico varchar(150),
@Origen varchar(350),
@Destino varchar(350),
@Estatus int,
@Ticket varchar(20),
@UbicacionActual varchar (1500), 
@TipoEntrega Varchar(50),
@HorasDetenido varchar(20),
@UltimoMovimientoGPS datetime = null, 
@DistanciaRuta numeric(18,2), 
@DistanciaRealizada numeric(18,2), 
@FechaCarga datetime = null,  
@FechaSalida datetime = null,
@FechaLlegada datetime = null, 
@FechaRetorno datetime = null,
@FechaCreacionViaje datetime,
@EtaDestino datetime,
@EtaRetorno datetime = null,
@Usuario Varchar(100),
@Trail Varchar(Max)
AS
BEGIN
	   -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'Los datos se guardaron correctamente.';

		--Variables que se utilizan para las subconsultas, datos que se deben traer de otras tablas
		DECLARE @ManifiestoId bigint;
		DECLARE @ClienteId bigint;
		Declare @Cliente2 varchar(200);
		DECLARE @TiempoRestante int = 0;
		Declare @PrioridadId bigint = 0;
		Declare @Reintentos int;
		DEclare @Restantes int;
		Declare @DiasLaborados int;
		Declare @UltimoServicio datetime;
		Declare @DiasTranscurridos int;
		Declare @CostoFlete numeric(18,2);
		Declare @GastosOperativos numeric(18,2);
		Declare @GastosIndirectos numeric(18,2);
		Declare @GastosNoJustificados numeric(18,2);
		Declare @FechaCargaEstimada datetime;
		Declare @FechaPromesaLlegada datetime;
		Declare @FechaPromesaRetorno datetime;
		Declare @Fechas datetime;
		Declare @TipoEntregaId bigint;
		Declare @FechaVentanaInicio datetime
		Declare @FechaVentanaFin datetime
		Declare @FechaSalidaEstimada datetime
		DEclare @Custodia bit
		DEclare @TicketId bigint
		Declare @FolioCompleto Varchar(12)
		Declare @Estatus2 int



		SET @TicketId =  Cast(@Ticket AS bigint ) ;
		
		SET @FolioCompleto =	(SELECT FORMAT(@TicketId, '00000000'))

		--Se hace una consulta a la tabla de Despachos.Despachos para obtener el ID del despacho, por el Folio del manifiesto
		SET @ManifiestoId = (Select Id from Despachos.Despachos where FolioDespacho = @Manifiesto)

		SET @Custodia = (Select Custodia from Despachos.Despachos where FolioDespacho = @Manifiesto)
		--select @ManifiestoId AS ManifiestiID
		--Se hace una consulta a la tabla de Clientes.Clientes para obtener el ID del cliente, se tiene la Razon social y se hace la busqueda por la misma.
		select @ClienteId = C.Id, @Cliente2 =  C.RazonSocial
			from Clientes.Clientes C
			inner join Despachos.Tickets T
			on C.Id = T.ClienteId
				Where T.FolioTicket = @FolioCompleto
		--select @ClienteId AS ClienteId
		--Se hace un calculo entre la EtaDestino y la FechaPromesaEntrega de la tabla de Despachos.Despachos, para obtener el tiempo que restante para la entrega de un ticket
		SET @TiempoRestante = (Select DATEDIFF(HOUR,@EtaDestino,(SELECT T.FechaPromesaEntrega FROM Despachos.TicketsAsignados T_A INNER JOIN Despachos.Tickets T ON T.Id = T_A.TicketId WHERE T_A.DespachoId = @ManifiestoId and T.FolioTicket = @Ticket)));
		--select @TiempoRestante AS TiempoRestante
		----Se hace una consulta a la tabla de Despachos.TicketsNoEntregados para obtener la priorodad de entrega de ticket, se hace la busqueda por el FolioTicket
		Select top 1 @PrioridadId = PrioridadId, @Reintentos = Reintentos, @Restantes = Restantes from Despachos.TicketsNoEntregados Where FolioTicket = @Ticket order by FechaCreacion desc
		--Se hace un calculo entre los viajes que hizo un operador en los ultimos 7 días, y se muestra el total de horas, se obtiene meidante la fecha de salida y la fehca de llagada
		SET @DiasLaborados = (select sum(DATEDIFF(HOUR, FechaSalida,FechaLlegada)) 
							from Despachos.Visores
								where FechaCreacionViaje >= DATEADD(DAY, -7, CURRENT_TIMESTAMP)
								and FechaCreacionViaje <= CURRENT_TIMESTAMP
							And Operador = @Operador );
		--select @DiasLaborados AS DiasLaborados
		--Se hace una consulta en la cual se calcula cual es el ultimo viaje de un  operador, se optiene mediante el nombre del operardor
		SET @UltimoServicio = (SELECT MAX(EtaRetorno) FROM Despachos.Visores where Operador = @Operador GROUP BY Operador);
		--select @UltimoServicio As UltimoServicio
		--Se hace un calculo para obtener los dias transcurridos del ultimo servicio al nuevo de un operador, se obtiene mediante la EtaRetorno y la FechaCracionViaje de un operador
		SET @DiasTranscurridos = (SELECT DATEDIFF(DAY,(SELECT MAX(EtaRetorno) FROM Despachos.Visores WHERE Operador = @Operador GROUP BY Operador),@FechaCreacionViaje));
		--select @DiasTranscurridos As DiasTranscurridos
		--Se hace una consulta para obtener el costo de la tarifa que tiene dada de alta un cliente que este vigente, se busca por cliente y costo de tarifa
		SET @CostoFlete = (Select top 1 T_F.Costo from Clientes.Tarifas T  Inner join Clientes.TiposTarifasClientes T_F on T_F.Id = T.TipoTarifaClienteId Where ClienteId = @ClienteId order by T.FechaCreacion desc);
	--	select @CostoFlete AS CostoFlete
		--Se hace un calculo en el cual se suman todos los gastos que esten liquidados por un despacho, obtenidos de la tabla de Despachos.RegistrosDispersiones haciendo un join a la tabla de Despachos.RegistrosLiquidacion
		SET @GastosOperativos = (SELECT SUM(D_R_L.Monto) FROM Despachos.RegistrosDispersiones D_R_D INNER JOIN Despachos.RegistrosLiquidaciones D_R_L ON D_R_D.DespachoId = D_R_L.DespachoId AND D_R_D.TipoGastoId = D_R_L.TipoGastoId WHERE D_R_D.DespachoId = @ManifiestoId and D_R_D.Eliminado = 1 and GastoOperativoId = 1);
		--select @GastosOperativos AS GastosOperativos
		--Se hace un calculo en el cual se suman todos los gastos que esten liquidados por un despacho, obtenidos de la tabla de Despachos.RegistrosDispersiones haciendo un join a la tabla de Despachos.RegistrosLiquidacion
		SET @GastosIndirectos = (SELECT SUM(D_R_L.Monto) FROM Despachos.RegistrosDispersiones D_R_D INNER JOIN Despachos.RegistrosLiquidaciones D_R_L ON D_R_D.DespachoId = D_R_L.DespachoId AND D_R_D.TipoGastoId = D_R_L.TipoGastoId WHERE D_R_D.DespachoId = @ManifiestoId and D_R_D.Eliminado = 1 and GastoOperativoId = 2);
	--	Select @GastosIndirectos AS GAstosIndirectos
		--Se hace un calculo en el cual se suman todos los gastos que aun no esten liquidados por un despacho, obtenidos de la tabla de Despachos.RegistrosDispersiones 
		SET @GastosNoJustificados = (SELECT SUM(Monto) FROM Despachos.RegistrosDispersiones D_R_D WHERE D_R_D.DespachoId = @ManifiestoId AND D_R_D.Eliminado = 1 AND D_R_D.TipoGastoId NOT IN (SELECT D_R_L.TipoGastoId FROM Despachos.RegistrosLiquidaciones D_R_L WHERE D_R_L.DespachoId = @ManifiestoId AND D_R_L.Eliminado = 1));
		----Se hace una consulta a la tabla de Tickets, para obtener la FechaPromesaCarga de un Ticket asignado a un despacho
		select @FechaSalidaEstimada = T.FechaSalidaEstimada, @FechaCargaEstimada = T.FechaPromesaCarga, @FechaPromesaLlegada = T.FechaPromesaLlegadaOrigen,  @FechaPromesaRetorno = T.FechaPromesaRetorno, @FechaVentanaInicio = T.FechaVentanaInicio, @FechaVentanaFin = T.FechaVentanaFin
		FROM Despachos.TicketsAsignados T_A INNER JOIN Despachos.Tickets T ON T.Id = T_A.TicketId WHERE T_A.DespachoId = @ManifiestoId and T.FolioTicket = @FolioCompleto

		Set @TipoEntregaId =
		CASE  
		WHEN Upper(LTRIM(RTRIM(@TipoEntrega))) = 'Recoleccion' THEN 1
		WHEN Upper(LTRIM(RTRIM(@TipoEntrega))) = 'Entrega' THEN 2
		END

		SET @Estatus2 =
		CASE
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 0 THEN 1
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 100 THEN 1
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 1 THEN 3
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 10 THEN 3
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 101 THEN 3
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 102 THEN 3
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 3 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 4 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 5 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 30 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 32 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 40 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 103 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 104 THEN 4
		WHEN Upper(LTRIM(RTRIM(@Estatus))) = 99 THEN 4
		END




			IF NOT EXISTS (SELECT FolioTicket from Despachos.Tickets where FolioTicket = @FolioCompleto )
			BEGIN
				SET @Mensaje = 'EL FoliTicket enviado no existe en la tabla de Tickets';
				SET @Resultado = ERROR_NUMBER() * -1;
				GOTO Salida;
			END


			IF NOT EXISTS (SELECT Manifiesto, Ticket from Despachos.Visores where Ticket = @FolioCompleto and Manifiesto = @Manifiesto)

			BEGIN
			BEGIN TRY
				INSERT INTO Despachos.Visores (
				Manifiesto, -- Manifiesto es un dato que se recibe de la tabla de TEA de avocado
				ClienteId,
				Cliente,
				Custodia,
				Operador,
				Vehiculo,
				Placa,
				Economico,
				Origen,
				Destino,
				VentanaAtencionInicio,
				VentanaAtencionFin,
				Estatus, -- Estatus es un dato que se recibe de la tabla de TEA de avocado
				ManifiestoId,
				Ticket,
				TiempoRestante,
				UbicacionActual, -- UbicacionActual es un dato que se recibe de la tabla de TEA de avocado
				TipoEntregaId, -- TipoEntregaId es un dato que se recibe de la tabla de TEA de avocado
				PrioridadId,
				Reintentos, -- Reintentos es un dato que se obtiene de la tabla TicketNoEntregado
				Restantes, -- Restantes es un dato que se obtiene de la tabla TicketNoEntregado
				DiasLaborados,
				UltimoServicio,
				DiasTranscurridos,
				HorasDetenido,
				CostoFlete,
				GastosOperativos, -- GastosOperativos se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				GastosIndirectos, -- GastosIndirectos se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				GastosNoJustificados, -- GastosNoJustificados se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				UltimoMovimientoGPS, -- UltimoMovimientoGPS es un dato que se recibe de la tabla de TEA de avocado
				DistanciaRuta, -- DistanciaRuta es un dato que se recibe de la tabla de TEA de avocado
				DistanciaRealizada, -- DistanciaRealizada es un dato que se recibe de la tabla de TEA de avocado
				FechaCargaEstimada, -- FechaCargaEstimada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaCarga, -- FechaCarga es un dato que se recibe de la tabla de TEA de avocado
				FechaSalidaEstimada, -- FechaSalidaEstimada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaSalida, -- FechaSalida es un dato que se recibe de la tabla de TEA de avocado
				FechaPromesaLlegada, -- FechaPromesaLlegada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaLlegada, -- FechaLlegada es un dato que se recibe de la tabla de TEA de avocado
				FechaPromesaRetorno, -- FechaPromesaRetorno es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaRetorno, -- FechaRetorno es un dato que se recibe de la tabla de TEA de avocado
				FechaCreacionViaje,
				EtaDestino,
				EtaRetorno,
				Eliminado,
				FechaCreacion,
				Usuario,
				Trail
				)

				values (
						@Manifiesto ,
						@ClienteId,
						@Cliente2,
						@Custodia,
						@Operador,
						@Vehiculo,
						@Placa,
						@Economico,
						@Origen,
						@Destino,
						@FechaVentanaInicio,
						@FechaVentanaFin,
						@Estatus2,
						@ManifiestoId,
						@FolioCompleto,
						@TiempoRestante,
						@UbicacionActual, 
						@TipoEntregaId,
						@PrioridadId,
						@Reintentos,
						@Restantes,
						@DiasLaborados,
						@UltimoServicio,
						@DiasTranscurridos,
						@HorasDetenido,
						@CostoFlete,
						@GastosOperativos,
						@GastosIndirectos,
						@GastosNoJustificados,
						@UltimoMovimientoGPS, 
						@DistanciaRuta, 
						@DistanciaRealizada, 
						@FechaCargaEstimada,
						(case when @FechaCarga = '' then null
						when @FechaCarga is not null and LTRIM(RTRIM(@FechaCarga )) <> '' then @FechaCarga 
						else null end
						),
						--@FechaCarga,
						@FechaSalidaEstimada,
						@FechaSalida,
						@FechaPromesaLlegada,
						(case when @FechaLlegada = '' then null
						when @FechaCarga is not null and LTRIM(RTRIM(@FechaLlegada )) <> '' then @FechaLlegada 
						else null end
						),
						--@FechaLlegada, 
						@FechaPromesaRetorno,
						(case when @FechaRetorno = '' then null
						when @FechaRetorno is not null and LTRIM(RTRIM(@FechaRetorno )) <> '' then @FechaRetorno 
						else null end
						),
						--@FechaRetorno,
						@FechaCreacionViaje,
						@EtaDestino,
						(case when @EtaRetorno = '' then null
						when @EtaRetorno is not null and LTRIM(RTRIM(@EtaRetorno )) <> '' then @EtaRetorno 
						else null end
						), 
						1,
						GETDATE(),
						@Usuario,
						@Trail
				)
				 
				SET @Mensaje = 'EL visor se guardo correctamente';
				END TRY
				
				
				BEGIN CATCH
				SET @Resultado = ERROR_NUMBER() * -1;
                SET @Mensaje = ERROR_MESSAGE();
				END CATCH
				END
				
				
				ELSE
				BEGIN
				BEGIN TRY
					UPDATE Despachos.Visores 
					SET Manifiesto = @Manifiesto, -- Manifiesto es un dato que se recibe de la tabla de TEA de avocado
				ClienteId = @ClienteId,
				Cliente = @Cliente2,
				--Custodia = @Custodia,
				Operador = @Operador,
				Vehiculo =@Vehiculo,
				Placa = @Placa,
				Economico = @Economico,
				Origen = @Origen,
				Destino = @Destino,
				VentanaAtencionInicio = @FechaVentanaInicio,
				VentanaAtencionFin = @FechaVentanaFin,
				Estatus = @Estatus2, -- Estatus es un dato que se recibe de la tabla de TEA de avocado
				ManifiestoId = @ManifiestoId,
				Ticket = @FolioCompleto,
				TiempoRestante = @TiempoRestante,
				UbicacionActual = @UbicacionActual, -- UbicacionActual es un dato que se recibe de la tabla de TEA de avocado
				TipoEntregaId = @TipoEntregaId, -- TipoEntregaId es un dato que se recibe de la tabla de TEA de avocado
				PrioridadId = @PrioridadId,
				Reintentos = @Reintentos, -- Reintentos es un dato que se obtiene de la tabla TicketNoEntregado
				Restantes = @Restantes, -- Restantes es un dato que se obtiene de la tabla TicketNoEntregado
				DiasLaborados = @DiasLaborados,
				UltimoServicio = @UltimoServicio,
				DiasTranscurridos = @DiasTranscurridos,
				HorasDetenido = @HorasDetenido,
				CostoFlete = @CostoFlete,
				GastosOperativos = @GastosOperativos, -- GastosOperativos se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				GastosIndirectos = @GastosIndirectos, -- GastosIndirectos se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				GastosNoJustificados = @GastosNoJustificados, -- GastosNoJustificados se calcula ccon el tipo de gasto obtenido de la tabla de RegistrosDispersiones
				UltimoMovimientoGPS = @UltimoMovimientoGPS, -- UltimoMovimientoGPS es un dato que se recibe de la tabla de TEA de avocado
				DistanciaRuta = @DistanciaRuta, -- DistanciaRuta es un dato que se recibe de la tabla de TEA de avocado
				DistanciaRealizada = @DistanciaRealizada, -- DistanciaRealizada es un dato que se recibe de la tabla de TEA de avocado
				FechaCargaEstimada = @FechaCargaEstimada, -- FechaCargaEstimada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaCarga = @FechaCarga, -- FechaCarga es un dato que se recibe de la tabla de TEA de avocado
				FechaSalidaEstimada = @FechaSalidaEstimada, -- FechaSalidaEstimada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaSalida = @FechaSalida, -- FechaSalida es un dato que se recibe de la tabla de TEA de avocado
				FechaPromesaLlegada = @FechaPromesaLlegada, -- FechaPromesaLlegada es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaLlegada = @FechaLlegada, -- FechaLlegada es un dato que se recibe de la tabla de TEA de avocado
				FechaPromesaRetorno = @FechaPromesaRetorno, -- FechaPromesaRetorno es un campo que se obtiene de la Tabla de BorradoresDesapchos
				FechaRetorno = @FechaRetorno, -- FechaRetorno es un dato que se recibe de la tabla de TEA de avocado
				FechaCreacionViaje = @FechaCreacionViaje,
				EtaDestino = @EtaDestino,
				EtaRetorno = @EtaRetorno,
				Usuario = @Usuario,
				Trail = @Trail
				Where Ticket = @FolioCompleto

				SET @Mensaje = 'EL visor se Actualizo correctamente';
				END TRY
				
				
				BEGIN CATCH
				SET @Resultado = ERROR_NUMBER() * -1;
                SET @Mensaje = ERROR_MESSAGE();
				END CATCH
				END

			SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS JsonSalida;
			
		END
GO
