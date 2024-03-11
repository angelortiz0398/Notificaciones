USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarTickets]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspInsertarActualizarTickets] 
		    @Json varchar(MAX) = NULL                               
AS
BEGIN
    -- Variables de control
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'Los tickets se guardaron correctamente.';
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT;

    -- Validación de parámetros
    IF @Json IS NULL 
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para insertar o actualizar los tickets';
            GOTO SALIDA;
        END
	ELSE IF ISJSON(@Json) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				SET @Mensaje = 'La información de los tickets no está en formato JSON esperado';
				GOTO SALIDA;				
			END;

    -- Inserta o actualiza el ticket
	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		Id bigint NOT NULL,
		FolioTicket varchar(20) NOT NULL,
		FolioTicketWMS varchar(20) NOT NULL,
		TipoFolio varchar(1) NULL,
		Origen varchar(500) NULL,
		ClienteId bigint NULL,
		DestinatariosId bigint NULL,
		Referencia varchar(50) NULL,
		SolicitaServicio varchar(150) NULL,
		FechaSolicitud datetime NULL,
		TipoSolicitudId bigint NULL,
		TipoEntregaId bigint NULL,
		Comentarios varchar(5000) NULL,
		EstatusId bigint NULL,
		TipoRecepcion varchar(1) NULL,
		Secuencia varchar(500) NULL,
		FechaSalidaEstimada datetime NULL,
		FechaPromesaLlegadaOrigen datetime NULL,
		FechaPromesaCarga datetime NULL,
		FechaPromesaEntrega datetime NULL,
		FechaPromesaRetorno datetime NULL,
		TiempoCarga time(7) NULL,
		TiempoParadaDestino time(7) NULL,
		FechaVentanaInicio datetime NULL,
		FechaVentanaFin datetime NULL,
		FechaRestriccionCirculacionInicio datetime NULL,
		FechaRestriccionCirculacionFin datetime NULL,
		Empaque varchar(max) NULL,
		Cantidad int NULL,
		SumaAsegurada numeric(18, 2) NULL,
		RutaId bigint NULL,
		TipoVehiculoId bigint NULL,
		HabilidadesVehiculo varchar(5000) NULL,
		DocumentosVehiculo varchar(5000) NULL,
		HabilidadesOperador varchar(5000) NULL,
		DocumentosOperador varchar(5000) NULL,
		HabilidadesAuxiliar varchar(5000) NULL,
		DocumentosAuxiliar varchar(5000) NULL,
		EvidenciaSalida varchar(5000) NULL,
		EvidenciaLlegada varchar(5000) NULL,
		CheckList varchar(5000) NULL,
		Maniobras int NULL,
		Peligroso varchar(150) NULL,
		Custodia varchar(150) NULL,
		CustodiaArmada varchar(150) NULL,
		TipoCustodiaId bigint NULL,
		RequiereEvidenciaSeguroSocial varchar(50) NULL,
		Seguro bit NULL,
		ServicioCobro bit NULL,
		ServicioAdicional varchar(max) NULL,
		RecepcionTicket datetime NULL,
		AsignacionManifiesto datetime NULL,
		InicioEscaneoRecepcionProducto datetime NULL,
		FinEscaneoRecepcionProducto datetime NULL,
		InicioEntregaProducto datetime NULL,
		FinEntregaProducto datetime NULL,
		DestinatariosClienteId bigint NULL,
		PrioridadId bigint NULL,
		Usuario varchar(150) NULL,
		Trail varchar(max) NOT NULL,
		RegistroNuevo BIT DEFAULT 1
	)
	-- Se inserta en la tabla temporal a partir del json 
	INSERT INTO #TablaTmp(
		Id
		,FolioTicket
		,FolioTicketWMS
		,TipoFolio
		,Origen
		,ClienteId
		,DestinatariosId
		,Referencia
		,SolicitaServicio
		,FechaSolicitud
		,TipoSolicitudId
		,TipoEntregaId
		,Comentarios
		,EstatusId
		,TipoRecepcion
		,Secuencia
		,FechaSalidaEstimada
		,FechaPromesaLlegadaOrigen
		,FechaPromesaCarga
		,FechaPromesaEntrega
		,FechaPromesaRetorno
		,TiempoCarga
		,TiempoParadaDestino
		,FechaVentanaInicio
		,FechaVentanaFin
		,FechaRestriccionCirculacionInicio
		,FechaRestriccionCirculacionFin
		,Empaque
		,Cantidad
		,SumaAsegurada
		,RutaId
		,TipoVehiculoId
		,HabilidadesVehiculo
		,DocumentosVehiculo
		,HabilidadesOperador
		,DocumentosOperador
		,HabilidadesAuxiliar
		,DocumentosAuxiliar
		,EvidenciaSalida
		,EvidenciaLlegada
		,CheckList
		,Maniobras
		,Peligroso
		,Custodia
		,CustodiaArmada
		,TipoCustodiaId
		,RequiereEvidenciaSeguroSocial
		,Seguro
		,ServicioCobro
		,ServicioAdicional
		,RecepcionTicket
		,AsignacionManifiesto
		,InicioEscaneoRecepcionProducto
		,FinEscaneoRecepcionProducto
		,InicioEntregaProducto
		,FinEntregaProducto
		,DestinatariosClienteId
		,PrioridadId
		,Usuario
		,Trail)
	SELECT * FROM OPENJSON (@Json)
	WITH
	(
		Id bigint,
		FolioTicket varchar(20),
		FolioTicketWMS varchar(20),
		TipoFolio varchar(1),
		Origen varchar(500),
		ClienteId bigint,
		DestinatariosId bigint,
		Referencia varchar(50),
		SolicitaServicio varchar(150),
		FechaSolicitud datetime,
		TipoSolicitudId bigint,
		TipoEntregaId bigint,
		Comentarios varchar(5000),
		EstatusId bigint,
		TipoRecepcion varchar(1),
		Secuencia varchar(500),
		FechaSalidaEstimada datetime,
		FechaPromesaLlegadaOrigen datetime,
		FechaPromesaCarga datetime,
		FechaPromesaEntrega datetime,
		FechaPromesaRetorno datetime,
		TiempoCarga time(7),
		TiempoParadaDestino time(7),
		FechaVentanaInicio datetime,
		FechaVentanaFin datetime,
		FechaRestriccionCirculacionInicio datetime,
		FechaRestriccionCirculacionFin datetime,
		Empaque varchar(max),
		Cantidad int,
		SumaAsegurada numeric(18, 2),
		RutaId bigint,
		TipoVehiculoId bigint,
		HabilidadesVehiculo varchar(5000),
		DocumentosVehiculo varchar(5000),
		HabilidadesOperador varchar(5000),
		DocumentosOperador varchar(5000),
		HabilidadesAuxiliar varchar(5000),
		DocumentosAuxiliar varchar(5000),
		EvidenciaSalida varchar(5000),
		EvidenciaLlegada varchar(5000),
		CheckList varchar(5000),
		Maniobras int,
		Peligroso varchar(150),
		Custodia varchar(150),
		CustodiaArmada varchar(150),
		TipoCustodiaId bigint,
		RequiereEvidenciaSeguroSocial varchar(50),
		Seguro bit,
		ServicioCobro bit,
		ServicioAdicional varchar(max),
		RecepcionTicket datetime,
		AsignacionManifiesto datetime,
		InicioEscaneoRecepcionProducto datetime,
		FinEscaneoRecepcionProducto datetime,
		InicioEntregaProducto datetime,
		FinEntregaProducto datetime,
		DestinatariosClienteId bigint,
		PrioridadId bigint,
		Usuario varchar(150),
		Trail varchar(max)
	)
	-- Se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
		Update #TablaTmp set RegistroNuevo = 0
		FROM #TablaTmp
		JOIN Despachos.Tickets on #TablaTmp.Id = Tickets.Id

    -- Inserta la información de aquellos que encuentra que son tickets nuevos y complementa con campos con información predefinida
	BEGIN TRANSACTION;
	BEGIN TRY
	INSERT INTO Despachos.Tickets(
		FolioTicket
		,FolioTicketWMS
		,TipoFolio
		,Origen
		,ClienteId
		,DestinatariosId
		,Referencia
		,SolicitaServicio
		,FechaSolicitud
		,TipoSolicitudId
		,TipoEntregaId
		,Comentarios
		,EstatusId
		,TipoRecepcion
		,Secuencia
		,FechaSalidaEstimada
		,FechaPromesaLlegadaOrigen
		,FechaPromesaCarga
		,FechaPromesaEntrega
		,FechaPromesaRetorno
		,TiempoCarga
		,TiempoParadaDestino
		,FechaVentanaInicio
		,FechaVentanaFin
		,FechaRestriccionCirculacionInicio
		,FechaRestriccionCirculacionFin
		,Empaque
		,Cantidad
		,SumaAsegurada
		,RutaId
		,TipoVehiculoId
		,HabilidadesVehiculo
		,DocumentosVehiculo
		,HabilidadesOperador
		,DocumentosOperador
		,HabilidadesAuxiliar
		,DocumentosAuxiliar
		,EvidenciaSalida
		,EvidenciaLlegada
		,CheckList
		,Maniobras
		,Peligroso
		,Custodia
		,CustodiaArmada
		,TipoCustodiaId
		,RequiereEvidenciaSeguroSocial
		,Seguro
		,ServicioCobro
		,ServicioAdicional
		,RecepcionTicket
		,AsignacionManifiesto
		,InicioEscaneoRecepcionProducto
		,FinEscaneoRecepcionProducto
		,InicioEntregaProducto
		,FinEntregaProducto
		,DestinatariosClienteId
		,PrioridadId
		,Usuario
		,Trail
		,FechaCreacion
		,Eliminado)
	SELECT
		FolioTicket
		,FolioTicketWMS
		,TipoFolio
		,Origen
		,ClienteId
		,DestinatariosId
		,Referencia
		,SolicitaServicio
		,FechaSolicitud
		,TipoSolicitudId
		,TipoEntregaId
		,Comentarios
		,EstatusId
		,TipoRecepcion
		,Secuencia
		,FechaSalidaEstimada
		,FechaPromesaLlegadaOrigen
		,FechaPromesaCarga
		,FechaPromesaEntrega
		,FechaPromesaRetorno
		,TiempoCarga
		,TiempoParadaDestino
		,FechaVentanaInicio
		,FechaVentanaFin
		,FechaRestriccionCirculacionInicio
		,FechaRestriccionCirculacionFin
		,Empaque
		,Cantidad
		,SumaAsegurada
		,RutaId
		,TipoVehiculoId
		,HabilidadesVehiculo
		,DocumentosVehiculo
		,HabilidadesOperador
		,DocumentosOperador
		,HabilidadesAuxiliar
		,DocumentosAuxiliar
		,EvidenciaSalida
		,EvidenciaLlegada
		,CheckList
		,Maniobras
		,Peligroso
		,Custodia
		,CustodiaArmada
		,TipoCustodiaId
		,RequiereEvidenciaSeguroSocial
		,Seguro
		,ServicioCobro
		,ServicioAdicional
		,RecepcionTicket
		,AsignacionManifiesto
		,InicioEscaneoRecepcionProducto
		,FinEscaneoRecepcionProducto
		,InicioEntregaProducto
		,FinEntregaProducto
		,DestinatariosClienteId
		,PrioridadId
		,Usuario
		,Trail
		, CURRENT_TIMESTAMP
		, 1
	FROM #TablaTmp
    WHERE RegistroNuevo = 1;
	-- Almacena la cantidad de registros insertados
	SET @RegistrosInsertados = @@ROWCOUNT;

	-- Seccion en donde se actualizan los registros que ya existian pero solo con la informacion que enviamos
	UPDATE Despachos.Tickets
	SET FolioTicket = tmp.FolioTicket
		,FolioTicketWMS = tmp.FolioTicketWMS
		,TipoFolio = tmp.TipoFolio
		,Origen = tmp.Origen
		,ClienteId = tmp.ClienteId
		,DestinatariosId = tmp.DestinatariosId
		,Referencia = tmp.Referencia
		,SolicitaServicio = tmp.SolicitaServicio
		,FechaSolicitud = tmp.FechaSolicitud
		,TipoSolicitudId = tmp.TipoSolicitudId
		,TipoEntregaId = tmp.TipoEntregaId
		,Comentarios = tmp.Comentarios
		,EstatusId = tmp.EstatusId
		,TipoRecepcion = tmp.TipoRecepcion
		,Secuencia = tmp.Secuencia
		,FechaSalidaEstimada = tmp.FechaSalidaEstimada
		,FechaPromesaLlegadaOrigen = tmp.FechaPromesaLlegadaOrigen
		,FechaPromesaCarga = tmp.FechaPromesaCarga
		,FechaPromesaEntrega = tmp.FechaPromesaEntrega
		,FechaPromesaRetorno = tmp.FechaPromesaRetorno
		,TiempoCarga = tmp.TiempoCarga
		,TiempoParadaDestino = tmp.TiempoParadaDestino
		,FechaVentanaInicio = tmp.FechaVentanaInicio
		,FechaVentanaFin = tmp.FechaVentanaFin
		,FechaRestriccionCirculacionInicio = tmp.FechaRestriccionCirculacionInicio
		,FechaRestriccionCirculacionFin = tmp.FechaRestriccionCirculacionFin
		,Empaque = tmp.Empaque
		,Cantidad = tmp.Cantidad
		,SumaAsegurada = tmp.SumaAsegurada
		,RutaId = tmp.RutaId
		,TipoVehiculoId = tmp.TipoVehiculoId
		,HabilidadesVehiculo = tmp.HabilidadesVehiculo
		,DocumentosVehiculo = tmp.DocumentosVehiculo
		,HabilidadesOperador = tmp.HabilidadesOperador
		,DocumentosOperador = tmp.DocumentosOperador
		,HabilidadesAuxiliar = tmp.HabilidadesAuxiliar
		,DocumentosAuxiliar = tmp.DocumentosAuxiliar
		,EvidenciaSalida = tmp.EvidenciaSalida
		,EvidenciaLlegada = tmp.EvidenciaLlegada
		,CheckList = tmp.CheckList
		,Maniobras = tmp.Maniobras
		,Peligroso = tmp.Peligroso
		,Custodia = tmp.Custodia
		,CustodiaArmada = tmp.CustodiaArmada
		,TipoCustodiaId = tmp.TipoCustodiaId
		,RequiereEvidenciaSeguroSocial = tmp.RequiereEvidenciaSeguroSocial
		,Seguro = tmp.Seguro
		,ServicioCobro = tmp.ServicioCobro
		,ServicioAdicional = tmp.ServicioAdicional
		,RecepcionTicket = tmp.RecepcionTicket
		,AsignacionManifiesto = tmp.AsignacionManifiesto
		,InicioEscaneoRecepcionProducto = tmp.InicioEscaneoRecepcionProducto
		,FinEscaneoRecepcionProducto = tmp.FinEscaneoRecepcionProducto
		,InicioEntregaProducto = tmp.InicioEntregaProducto
		,FinEntregaProducto = tmp.FinEntregaProducto
		,DestinatariosClienteId = tmp.DestinatariosClienteId
		,PrioridadId = tmp.PrioridadId
		,Usuario = tmp.Usuario
		,Trail = tmp.Trail
	FROM #TablaTmp tmp
	WHERE Despachos.Tickets.[Id] = tmp.[Id]
		AND tmp.RegistroNuevo = 0;
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

	-- Se validara que se insertaron o actualizaron la misma cantidad de tickets que se enviaron
	IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM #TablaTmp))
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'Los tickets se guardaron correctamente.';
	END
	ELSE
	BEGIN
		SET @Resultado = -1;
		SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json';
	END

	-- Elimina la tabla temporal
	DROP TABLE #TablaTmp;

    -- Devuelve el resultado de la inserción o actualización del ticket
    SALIDA:
        SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
