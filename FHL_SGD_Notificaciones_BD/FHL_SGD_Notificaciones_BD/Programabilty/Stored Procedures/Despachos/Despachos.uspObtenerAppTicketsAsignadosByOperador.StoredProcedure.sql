USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAppTicketsAsignadosByOperador]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Noviembre de 2023
-- Description:	Obtiene la lista de tickets ligados a un Manifiesto/Despacho pasado como parámetro
-- =============================================
-- Parameters:	@FolioDespacho	=> Folio del Despacho del cual se mostrarán los tickets relacionados (Requerido)
--				@FolioTicket	=> Folio del Ticket a buscar (Opcional)
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAppTicketsAsignadosByOperador]
	-- Add the parameters for the stored procedure here
	@FolioDespacho					VARCHAR(MAX) = NULL,
	@FolioTicket					VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode			INT = 0;
	DECLARE @Message				VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data					VARCHAR(MAX) = NULL;
	-- Número de registros totales antes de la paginación
	DECLARE @TotalRows				INT = 0;
	-- Tabla variable para el manejo de la información
	DECLARE @CteTicketsXDespacho TABLE(
		Id							BIGINT,
		TicketId					BIGINT,
		FolioEta					VARCHAR(MAX),
		FolioTicket					VARCHAR(MAX),
		Origen						VARCHAR(MAX),
		ClienteId					BIGINT,
		DestinatariosId				BIGINT,
		Referencia					VARCHAR(MAX),
		TipoSolicitudId				BIGINT,
		TipoEntregaId				BIGINT,
		Comentarios					VARCHAR(MAX),
		EstatusId					BIGINT,
		TipoRecepcion				VARCHAR(1),				
		Secuencia					VARCHAR(MAX),
		/*
		FechaPromesaLlegadaOrigen	DATETIME,
		FechaPromesaCarga			DATETIME,
		FechaPromesaEntrega			DATETIME,
		FechaVentanaInicio			DATETIME,
		FechaVentanaFin				DATETIME,
		FechaRestriccionCirculacionInicio	DATETIME,
		FechaRestriccionCirculacionFin		DATETIME,
		*/
		FechaPromesaRetorno			DATETIME,
		FechaSalidaEstimada			DATETIME,
		TiempoCarga					TIME(7),
		TiempoParadaDestino			TIME(7),
		RutaId						BIGINT,
		TipoVehiculoId				BIGINT,
		DocumentosVehiculo			VARCHAR(MAX),
		HabilidadesOperador			VARCHAR(MAX),
		DocumentosOperador			VARCHAR(MAX),
		HabilidadesAuxiliar			VARCHAR(MAX),
		DocumentosAuxiliar			VARCHAR(MAX),
		EvidenciaSalida				VARCHAR(MAX),
		EvidenciaLlegada			VARCHAR(MAX),
		CheckList					VARCHAR(MAX),
		RecepcionTicket				DATETIME,
		AsignacionManifiesto		DATETIME,
		InicioEscaneoRecepcionProducto		DATETIME,
		FinEscaneoRecepcionProducto			DATETIME,
		InicioEntregaProducto		DATETIME,
		FinEntregaProducto			DATETIME,
		DestinatariosClienteId		BIGINT
	);


    -- Valida la información recibida como parámetro
	IF @FolioDespacho IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible consultar la lista de tickets porque no se ha proporcionado el Identificador del Despacho';
			GOTO SALIDA;
		END
	ELSE
		BEGIN
			-- Determina si el despacho se encuentra registrado
			SELECT @TotalRows = Id FROM Despachos.Despachos
			WHERE FolioDespacho = @FolioDespacho
			AND Eliminado = 1;

			IF @TotalRows = 0
				BEGIN
					SET @ResponseCode = -2;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'El Despacho proporcionado no existe o ha sido eliminado';
					GOTO SALIDA;					
				END
		END


	-- Obtiene la lista de Tickets ligados al Despacho pasado como parámetro
		INSERT @CteTicketsXDespacho
			SELECT
				Ticket.Id,
				TicketVsDespacho.TicketId,
				TicketVsDespacho.FolioEta,
				Ticket.FolioTicket,
				Ticket.Origen,
				Ticket.ClienteId,
				Ticket.DestinatariosId,
				Ticket.Referencia,
				Ticket.TipoSolicitudId,
				Ticket.TipoEntregaId,
				Ticket.Comentarios,
				Ticket.EstatusId,
				Ticket.TipoRecepcion,
				Ticket.Secuencia,
				/*
				Ticket.FechaPromesaLlegadaOrigen,
				Ticket.FechaPromesaCarga,
				Ticket.FechaPromesaEntrega,
				Ticket.FechaVentanaInicio,
				Ticket.FechaVentanaFin,
				Ticket.FechaRestriccionCirculacionInicio,
				Ticket.FechaRestriccionCirculacionFin,
				*/
				Ticket.FechaPromesaRetorno,
				Ticket.FechaSalidaEstimada,
				Ticket.TiempoCarga,
				Ticket.TiempoParadaDestino,
				Ticket.RutaId,
				Ticket.TipoVehiculoId,
				Ticket.DocumentosVehiculo,
				Ticket.HabilidadesOperador,
				Ticket.DocumentosOperador,
				Ticket.HabilidadesAuxiliar,
				Ticket.DocumentosAuxiliar,
				Ticket.EvidenciaSalida,
				Ticket.EvidenciaLlegada,
				Ticket.CheckList,
				Ticket.RecepcionTicket,
				Ticket.AsignacionManifiesto,
				Ticket.InicioEscaneoRecepcionProducto,
				Ticket.FinEscaneoRecepcionProducto,
				Ticket.InicioEntregaProducto,
				Ticket.FinEntregaProducto,
				Ticket.DestinatariosClienteId
			FROM Despachos.TicketsAsignados TicketVsDespacho
			INNER JOIN Despachos.Tickets Ticket
				ON Ticket.Id = TicketVsDespacho.TicketId
				AND Ticket.Eliminado = 1
			INNER JOIN Despachos.Despachos Despachos
				ON Despachos.Id = TicketVsDespacho.DespachoId
				AND Despachos.Eliminado = 1
			WHERE
				--TicketVsDespacho.DespachoId = @DespachoId
				Despachos.FolioDespacho = @FolioDespacho
				AND TicketVsDespacho.Eliminado = 1
				AND ( @FolioTicket IS NULL OR Ticket.FolioTicket LIKE '%' + @FolioTicket + '%' );
	-- Determina el número de registros principales encontrados (Tickets por Despacho)
	SELECT @TotalRows = COUNT(*) FROM @CteTicketsXDespacho;


	-- Devuelve la información recopilada en la ejecución del script
	SALIDA:
		-- Determina si debe mostrar el número de registros encontrados o el error generado
		IF @ResponseCode >= 0 SET @ResponseCode = @TotalRows ELSE SET @TotalRows = @ResponseCode;

		-- Devuelve las columnas de información
		SELECT
			@TotalRows AS TotalRows,
			'{' +
				'"responseCode": ' + CAST(@ResponseCode AS VARCHAR(MAX)) + ',' +
				'"message":"' + @Message + '",' +
				'"data":' + (
					CASE
						-- Información de los Tickets encontrados
						WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN
							(
								SELECT
									TicketsXDespacho.Id,
									TicketsXDespacho.TicketId,
									TicketsXDespacho.FolioEta,
									TicketsXDespacho.FolioTicket,
									TicketsXDespacho.Origen,
									-- Cliente
										TicketsXDespacho.ClienteId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															Clientes.Id,
															Clientes.RazonSocial,
															Clientes.RFC
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS Cliente,
									-- Destinatarios
										TicketsXDespacho.DestinatariosId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															Destinatarios.Id,
															Destinatarios.RazonSocial,
															Destinatarios.RFC,
															Destinatarios.Coordenadas,
															Destinatarios.CodigoPostal,
															Destinatarios.Colonia,
															Destinatarios.Localidad,
															Destinatarios.Municipio,
															Destinatarios.Estado,
															Destinatarios.Pais,
															-- Obtiene el Identificador del contacto
																(
																	SELECT
																		CAST(
																			JSON_VALUE(
																				JSON_QUERY(
																					( SELECT Destinatarios.Contacto	)
																				), '$."Id"'
																			)
																		AS BIGINT)
																) AS ContactoId,
															-- Convierte la cadena de texto en un JSON
																JSON_QUERY(
																	(
																		SELECT Destinatarios.Contacto
																	)
																) AS Contacto
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS Destinatarios,
									--
									TicketsXDespacho.Referencia,
									TicketsXDespacho.TipoSolicitudId,
									-- Tipo de Entrega
										TicketsXDespacho.TipoEntregaId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															TicketsXDespacho.TipoEntregaId AS Id,
															(
																CASE
																	WHEN TicketsXDespacho.TipoEntregaId = 1 THEN 'Recolección'
																	ELSE 'Entrega' END
															) AS Nombre
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS TipoEntrega,
									--
									TicketsXDespacho.Comentarios,
									-- Estatus
										TicketsXDespacho.EstatusId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															TicketsXDespacho.EstatusId AS Id,
															(
																CASE
																	WHEN TicketsXDespacho.EstatusId = 1 THEN 'En cola'
																	WHEN TicketsXDespacho.EstatusId = 2 THEN 'Asignado'
																	WHEN TicketsXDespacho.EstatusId = 3 THEN 'En ruta'
																	WHEN TicketsXDespacho.EstatusId = 4 THEN 'Entregado'
																	WHEN TicketsXDespacho.EstatusId = 5 THEN 'No Entregado'
																	WHEN TicketsXDespacho.EstatusId = 6 THEN 'Transferido'
																	ELSE 'Estatus no registrado' END
															) AS Nombre
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS Estatus,
									--
									TicketsXDespacho.TipoRecepcion,
									TicketsXDespacho.Secuencia,
									/*
									TicketsXDespacho.FechaPromesaLlegadaOrigen,
									TicketsXDespacho.FechaPromesaCarga,
									TicketsXDespacho.FechaPromesaEntrega,
									TicketsXDespacho.FechaVentanaInicio,
									TicketsXDespacho.FechaVentanaFin,
									TicketsXDespacho.FechaRestriccionCirculacionInicio,
									TicketsXDespacho.FechaRestriccionCirculacionFin,
									*/
									TicketsXDespacho.FechaPromesaRetorno,
									TicketsXDespacho.FechaSalidaEstimada,
									TicketsXDespacho.TiempoCarga,
									TicketsXDespacho.TiempoParadaDestino,
									-- Rutas
										RutaId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															Rutas.Id,
															Rutas.Nombre
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS Ruta,
									-- Tipo de Vehículo
										TipoVehiculoId,
										JSON_QUERY(
											(
												CASE WHEN @FolioTicket IS NOT NULL THEN
													(
														SELECT
															VehiculoTipo.Id,
															VehiculoTipo.Nombre
														FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
													)
												END
											)
										) AS TipoVehiculo,
									-- Documentos del Vehiculo
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.DocumentosVehiculo)
											END
										) AS DocumentosVehiculo,
									-- Habilidades del Operador
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.HabilidadesOperador)
											END
										) AS HabilidadesOperador,
									-- Documentos del Operador
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.DocumentosOperador)
											END
										) AS DocumentosOperador,
									-- Habilidades del Auxiliar
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.HabilidadesAuxiliar)
											END
										) AS HabilidadesAuxiliar,
									-- Documentos del Auxiliar
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.DocumentosAuxiliar)
											END
										) AS DocumentosAuxiliar,
									-- Evidencia de Salida
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.EvidenciaSalida)
											END
										) AS EvidenciaSalida,
									-- Evidencia de Llegada
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.EvidenciaLlegada)
											END
										) AS EvidenciaLlegada,
									-- Checklist
										JSON_QUERY(
											CASE WHEN @FolioTicket IS NOT NULL THEN
												(SELECT TicketsXDespacho.CheckList)
											END
										) AS CheckList,
									--
									TicketsXDespacho.RecepcionTicket,
									TicketsXDespacho.AsignacionManifiesto,
									TicketsXDespacho.InicioEscaneoRecepcionProducto,
									TicketsXDespacho.FinEscaneoRecepcionProducto,
									TicketsXDespacho.InicioEntregaProducto,
									TicketsXDespacho.FinEntregaProducto,
									TicketsXDespacho.DestinatariosClienteId
								FROM @CteTicketsXDespacho TicketsXDespacho
								LEFT JOIN Operadores.Rutas Rutas
									ON Rutas.Id = TicketsXDespacho.RutaId
								LEFT JOIN Vehiculos.Tipos VehiculoTipo
									ON VehiculoTipo.Id = TicketsXDespacho.TipoVehiculoId
								LEFT JOIN Clientes.Clientes Clientes
									ON Clientes.Id = TicketsXDespacho.ClienteId
								LEFT JOIN Clientes.Destinatarios Destinatarios
									ON TicketsXDespacho.DestinatariosId = Destinatarios.Id
								FOR JSON PATH
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
