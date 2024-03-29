USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarVisores]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspInsertarActualizarVisores] 
		    @Lista varchar(MAX) = NULL                              
AS
BEGIN
    -- Variables de control
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'Los visores se guardaron correctamente.';
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT;

	DECLARE @ControlRegistros TABLE (IdInsertados bigint, IdActualizados bigint); --Tabla en la cual guardaremos los Id insertados y su relación


    -- Validación de parámetros
    IF @Lista IS NULL 
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para insertar o actualizar el despacho';
            GOTO SALIDA;
        END
	ELSE IF ISJSON(@Lista) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				SET @Mensaje = 'La información del despacho no está en formato JSON esperado';
				GOTO SALIDA;				
			END;


	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	DECLARE @TablaTmp TABLE(
		Id bigint  NOT NULL,
		Manifiesto varchar(20) NOT NULL,
		ClienteId bigint NULL,
		Cliente varchar(300) NULL,
		Custodia bit NULL,
		Operador varchar(350) NULL,
		Vehiculo varchar(150) NOT NULL,
		Placa varchar(50) NOT NULL,
		Economico varchar(150) NOT NULL,
		Origen varchar(350) NOT NULL,
		Destino varchar(350) NOT NULL,
		VentanaAtencionInicio varchar(100) NOT NULL,
		VentanaAtencionFin varchar(100) NOT NULL,
		Estatus int NULL,
		ManifiestoId bigint NULL,
		Ticket varchar(20) NULL,
		TiempoRestante int NULL,
		UbicacionActual varchar(1500) NULL,
		TipoEntregaId bigint NULL,
		PrioridadId bigint NULL,
		Reintentos int NULL,
		Restantes int NULL,
		Ubicacion varchar(500) NULL,
		DiasLaborados int NULL,
		UltimoServicio datetime NULL,
		DiasTranscurridos int NULL,
		HorasDetenido varchar(20) NULL,
		CostoFlete numeric(18, 2) NULL,
		GastosOperativos numeric(18, 2) NULL,
		GastosIndirectos numeric(18, 2) NULL,
		GastosNoJustificados numeric(18, 2) NULL,
		UltimoMovimientoGPS datetime NULL,
		DistanciaRuta numeric(18, 2) NULL,
		DistanciaRealizada numeric(18, 2) NULL,
		FechaCargaEstimada datetime NULL,
		FechaCarga datetime NULL,
		FechaSalidaEstimada datetime NULL,
		FechaSalida datetime NULL,
		FechaPromesaLlegada datetime NULL,
		FechaLlegada datetime NULL,
		FechaPromesaRetorno datetime NULL,
		FechaRetorno datetime NULL,
		FechaCreacionViaje datetime NULL,
		EtaDestino datetime NULL,
		EtaRetorno datetime NULL,
		Usuario varchar(150) NULL,
		Eliminado bit NULL,
		FechaCreacion datetime NULL,
		Trail varchar(max) NULL
		)
	-- Se inserta en la tabla temporal a partir del json 
		INSERT INTO @TablaTmp(
			Id
			,Manifiesto
			,ClienteId
			,Cliente
			,Custodia
			,Operador
			,Vehiculo
			,Placa
			,Economico
			,Origen
			,Destino
			,VentanaAtencionInicio
			,VentanaAtencionFin
			,Estatus
			,ManifiestoId
			,Ticket
			,TiempoRestante
			,UbicacionActual
			,TipoEntregaId
			,PrioridadId
			,Reintentos
			,Restantes
			,Ubicacion
			,DiasLaborados
			,UltimoServicio
			,DiasTranscurridos
			,HorasDetenido
			,CostoFlete
			,GastosOperativos
			,GastosIndirectos
			,GastosNoJustificados
			,UltimoMovimientoGPS
			,DistanciaRuta
			,DistanciaRealizada
			,FechaCargaEstimada
			,FechaCarga
			,FechaSalidaEstimada
			,FechaSalida
			,FechaPromesaLlegada
			,FechaLlegada
			,FechaPromesaRetorno
			,FechaRetorno
			,FechaCreacionViaje
			,EtaDestino
			,EtaRetorno
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail)
		SELECT * FROM OPENJSON (@Lista)
		WITH
		(
			Id bigint,
			Manifiesto varchar(20),
			ClienteId bigint,
			Cliente varchar(300),
			Custodia bit,
			Operador varchar(350),
			Vehiculo varchar(150),
			Placa varchar(50),
			Economico varchar(150),
			Origen varchar(350),
			Destino varchar(350),
			VentanaAtencionInicio varchar(100),
			VentanaAtencionFin varchar(100),
			Estatus int,
			ManifiestoId bigint,
			Ticket varchar(20),
			TiempoRestante int,
			UbicacionActual varchar(1500),
			TipoEntregaId bigint,
			PrioridadId bigint,
			Reintentos int,
			Restantes int,
			Ubicacion varchar(500),
			DiasLaborados int,
			UltimoServicio datetime,
			DiasTranscurridos int,
			HorasDetenido varchar(20),
			CostoFlete numeric(18, 2),
			GastosOperativos numeric(18, 2),
			GastosIndirectos numeric(18, 2),
			GastosNoJustificados numeric(18, 2),
			UltimoMovimientoGPS datetime,
			DistanciaRuta numeric(18, 2),
			DistanciaRealizada numeric(18, 2),
			FechaCargaEstimada datetime,
			FechaCarga datetime,
			FechaSalidaEstimada datetime,
			FechaSalida datetime,
			FechaPromesaLlegada datetime,
			FechaLlegada datetime,
			FechaPromesaRetorno datetime,
			FechaRetorno datetime,
			FechaCreacionViaje datetime,
			EtaDestino datetime,
			EtaRetorno datetime,
			Usuario varchar(150),
			Eliminado bit,
			FechaCreacion datetime,
			Trail varchar(max)
		)


		-- Inserta la información de aquellos que encuentra que son visores nuevos y complementa con campos con información predefinida
		BEGIN TRANSACTION;
		BEGIN TRY
		INSERT INTO Despachos.Visores(
			Manifiesto
			,ClienteId
			,Cliente
			,Custodia
			,Operador
			,Vehiculo
			,Placa
			,Economico
			,Origen
			,Destino
			,VentanaAtencionInicio
			,VentanaAtencionFin
			,Estatus
			,ManifiestoId
			,Ticket
			,TiempoRestante
			,UbicacionActual
			,TipoEntregaId
			,PrioridadId
			,Reintentos
			,Restantes
			,Ubicacion
			,DiasLaborados
			,UltimoServicio
			,DiasTranscurridos
			,HorasDetenido
			,CostoFlete
			,GastosOperativos
			,GastosIndirectos
			,GastosNoJustificados
			,UltimoMovimientoGPS
			,DistanciaRuta
			,DistanciaRealizada
			,FechaCargaEstimada
			,FechaCarga
			,FechaSalidaEstimada
			,FechaSalida
			,FechaPromesaLlegada
			,FechaLlegada
			,FechaPromesaRetorno
			,FechaRetorno
			,FechaCreacionViaje
			,EtaDestino
			,EtaRetorno
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail)
		SELECT
			Manifiesto
			,ClienteId
			,Cliente
			,Custodia
			,Operador
			,Vehiculo
			,Placa
			,Economico
			,Origen
			,Destino
			,VentanaAtencionInicio
			,VentanaAtencionFin
			,Estatus
			,ManifiestoId
			,Ticket
			,TiempoRestante
			,UbicacionActual
			,TipoEntregaId
			,PrioridadId
			,Reintentos
			,Restantes
			,Ubicacion
			,DiasLaborados
			,UltimoServicio
			,DiasTranscurridos
			,HorasDetenido
			,CostoFlete
			,GastosOperativos
			,GastosIndirectos
			,GastosNoJustificados
			,UltimoMovimientoGPS
			,DistanciaRuta
			,DistanciaRealizada
			,FechaCargaEstimada
			,FechaCarga
			,FechaSalidaEstimada
			,FechaSalida
			,FechaPromesaLlegada
			,FechaLlegada
			,FechaPromesaRetorno
			,FechaRetorno
			,FechaCreacionViaje
			,EtaDestino
			,EtaRetorno
			,Usuario
			, 1
			, CURRENT_TIMESTAMP
			,Trail
		FROM @TablaTmp WHERE Id = 0;

		-- Almacena la cantidad de registros insertados
		SET @RegistrosInsertados = @@ROWCOUNT;

		-- Seccion en donde se actualizan los registros que ya existian pero solo con la informacion que enviamos
		UPDATE Despachos.Visores
		SET Manifiesto = tmp.Manifiesto
			,ClienteId = tmp.ClienteId
			,Cliente = tmp.Cliente
			,Custodia = tmp.Custodia
			,Operador = tmp.Operador
			,Vehiculo = tmp.Vehiculo
			,Placa = tmp.Placa
			,Economico = tmp.Economico
			,Origen = tmp.Origen
			,Destino = tmp.Destino
			,VentanaAtencionInicio = tmp.VentanaAtencionInicio
			,VentanaAtencionFin = tmp.VentanaAtencionFin
			,Estatus = tmp.Estatus
			,ManifiestoId = tmp.ManifiestoId
			,Ticket = tmp.Ticket
			,TiempoRestante = tmp.TiempoRestante
			,UbicacionActual = tmp.UbicacionActual
			,TipoEntregaId = tmp.TipoEntregaId
			,PrioridadId = tmp.PrioridadId
			,Reintentos = tmp.Reintentos
			,Restantes = tmp.Restantes
			,Ubicacion = tmp.Ubicacion
			,DiasLaborados = tmp.DiasLaborados
			,UltimoServicio = tmp.UltimoServicio
			,DiasTranscurridos = tmp.DiasTranscurridos
			,HorasDetenido = tmp.HorasDetenido
			,CostoFlete = tmp.CostoFlete
			,GastosOperativos = tmp.GastosOperativos
			,GastosIndirectos = tmp.GastosIndirectos
			,GastosNoJustificados = tmp.GastosNoJustificados
			,UltimoMovimientoGPS = tmp.UltimoMovimientoGPS
			,DistanciaRuta = tmp.DistanciaRuta
			,DistanciaRealizada = tmp.DistanciaRealizada
			,FechaCargaEstimada = tmp.FechaCargaEstimada
			,FechaCarga = tmp.FechaCarga
			,FechaSalidaEstimada = tmp.FechaSalidaEstimada
			,FechaSalida = tmp.FechaSalida
			,FechaPromesaLlegada = tmp.FechaPromesaLlegada
			,FechaLlegada = tmp.FechaLlegada
			,FechaPromesaRetorno = tmp.FechaPromesaRetorno
			,FechaRetorno = tmp.FechaRetorno
			,FechaCreacionViaje = tmp.FechaCreacionViaje
			,EtaDestino = tmp.EtaDestino
			,EtaRetorno = tmp.EtaRetorno
			,Usuario = tmp.Usuario
			,Trail = tmp.Trail
		FROM @TablaTmp tmp
		WHERE Despachos.Visores.Id = tmp.Id

		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error para guardar los registros';
			ROLLBACK;
			GOTO SALIDA;
		END CATCH
	-- Almacena la cantidad de registros actualizados
		SET @RegistrosActualizados = @@ROWCOUNT;

	-- Se validara que se insertaron o actualizaron la misma cantidad de visores que se enviaron
	IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM @TablaTmp))
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'El registro se guardo correctamente.';
	END
	ELSE
	BEGIN
		SET @Resultado = -1;
		SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json';
	END
    -- Devuelve el resultado de la inserción o actualización del ticket
    SALIDA:
        SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
