USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarAppTicketsNoEntregados]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newlandapps
-- Create date: Febrero de 2024
-- Description:	Inserta o actualiza un ticket que cae en el estado de no entregado
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarActualizarAppTicketsNoEntregados]
	-- Add the parameters for the stored procedure here
	@FolioDespacho				VARCHAR(MAX) = NULL,
	@FolioTicket				VARCHAR(MAX) = NULL,
	@CausaCambioId				BIGINT = NULL,
	@Usuario					VARCHAR(MAX) = NULL,
	@Trail						VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode		INT = 0;
	DECLARE @Message			VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data				VARCHAR(MAX) = NULL;
	-- Número de registros totales actualizados/registrados
	DECLARE @TotalRows			INT = 0;
	-- Número de registros en las que se encuentra asignado el ticket y el manifiesto
	DECLARE @TotalRowsManifiestoVsTicketAsignado		INT = 0;
	-- Determina si debe insertar o actualizar el ticket como no entregado
	DECLARE @NuevoRegistroTicketNoEntregado				BIT = 0;
	DECLARE @IdTicketNoEntregado						BIGINT = 0;
	DECLARE @DespachoId			BIGINT = 0;
	DECLARE @TicketId			BIGINT = 0;
	DECLARE @PrioridadId		BIGINT = 0;
	DECLARE @TipoEntregaId		BIGINT = 0;
	-- Número de Reintentos y Restantes para el Ticket No Entregado. Valores iniciales para un nuevo ticket y en caso de ser una actualización se modificarán los valores
	DECLARE @Reintentos			INT = 0;
	DECLARE @Restantes			INT = 3;

	
	-- 1. Valida la información recibida como parámetros
		IF	(@FolioDespacho IS NULL OR NULLIF(LTRIM(RTRIM(@FolioDespacho)), '') IS NULL) OR
			(@FolioTicket IS NULL OR NULLIF(LTRIM(RTRIM(@FolioTicket)), '') IS NULL) OR
			(@CausaCambioId IS NULL OR NULLIF(LTRIM(RTRIM(@CausaCambioId)), '') IS NULL) OR
			(@Usuario IS NULL OR NULLIF(LTRIM(RTRIM(@Usuario)), '') IS NULL) OR
			(@Trail IS NULL OR NULLIF(LTRIM(RTRIM(@Trail)), '') IS NULL)
			BEGIN
				-- La información a guardar está incompleta
				SET @ResponseCode = -1;
				SET @Message = 'No es posible guardar la evidencia ya que se ha proporcionado la información necesaria';
				GOTO SALIDA;
			END

		-- Valida que el ticket este asignado al folio del despacho
		-- Determina el Identificador del Despacho
		SELECT	@DespachoId = Id FROM Despachos.Despachos
				WHERE FolioDespacho = @FolioDespacho
				AND Eliminado = 1
				AND Borrador = 0
				AND EstatusId IN (2,3);
		-- Determina la información adicional del Ticket
		SELECT	@TicketId = Id,
				@TipoEntregaId = TipoEntregaId,
				@PrioridadId = PrioridadId
				FROM Despachos.Tickets
				WHERE FolioTicket = @FolioTicket
				AND Eliminado = 1;
		-- Determina cuantos registros se tiene registrado el Despacho confirmado y el Ticket
		SELECT @TotalRowsManifiestoVsTicketAsignado = COUNT(*)
		FROM Despachos.TicketsAsignados
		WHERE
			DespachoId = @DespachoId
			AND TicketId = @TicketId
			AND Eliminado = 1

		-- El Ticket no se ha asignado al Despacho o está asignado a un Despacho varias veces presentando inconsistencias
		IF @TotalRowsManifiestoVsTicketAsignado <> 1
			BEGIN
				SET @ResponseCode = -2;
				SET @Message = 'El ticket pasado como parámetro no ha sido asignado al Despacho o se encuentra registrado más de una vez con el mismo Despacho';
				GOTO SALIDA;
			END

		-- Valida que el Estatus que indica la razón del porque no ha sido entregado sea válido
		IF (SELECT COUNT(Id) FROM Despachos.CausasCambios WHERE Id = @CausaCambioId AND Eliminado = 1) <> 1
			BEGIN
				SET @ResponseCode = -3;
				SET @Message = 'El motivo de la NO Entrega no es válido ya que no está registrado';
				GOTO SALIDA;			
			END



	-- 2. Determina si debe insertar o actualizar el registro pero antes validar si se tienen reintentos disponibles

		SELECT
			@IdTicketNoEntregado = Id,
			@NuevoRegistroTicketNoEntregado = COUNT(Id),
			@Reintentos = Reintentos,
			@Restantes = Restantes
		FROM Despachos.TicketsNoEntregados
		WHERE TicketId = @TicketId
		AND DespachoId = @DespachoId
		GROUP BY Id, Reintentos, Restantes
			
		-- Se han terminado los reintentos disponibles para el ticket
		IF @Restantes = 0 AND @NuevoRegistroTicketNoEntregado > 0
			BEGIN
				SET @ResponseCode = -4;
				SET @Message = 'El ticket ha superado el número de reintentos permitidos: ' + CAST(@Restantes AS VARCHAR(MAX)) + ' reintento(s) disponible(s)';
				GOTO SALIDA;
			END
			


		BEGIN TRANSACTION
			BEGIN TRY
				IF @NuevoRegistroTicketNoEntregado = 0
					BEGIN
						-- Registra un nuevo ticket que no ha sido entregado
						INSERT INTO Despachos.TicketsNoEntregados (
							DespachoId,
							FolioDespacho,
							TicketId,
							FolioTicket,
							PrioridadId,
							TipoEntregaId,
							Reintentos,
							Restantes,
							CausaCambioId,
							Usuario,
							Eliminado,
							FechaCreacion,
							Trail
						) VALUES (
							@DespachoId,
							@FolioDespacho,
							@TicketId,
							@FolioTicket,
							@PrioridadId,
							@TipoEntregaId,
							0,
							3,
							@CausaCambioId,
							@Usuario,
							1,
							CURRENT_TIMESTAMP,
							REPLACE(@Trail,'||--ACCION--||','Alta de registro')
						);
						-- Determina el Identificador con el cual se insertó el registro
						SET @TotalRows = SCOPE_IDENTITY();
						-- Confirma la inserción
						COMMIT;
					END
				ELSE
					BEGIN
						-- Ya existe previamente el registro del Ticket por lo que se actualiza el número de reintentos
						SET @Reintentos = @Reintentos + 1;
						SET @Restantes = @Restantes - 1;

						-- Actualiza la información del registro
						-- La funcíón JSON_QUERY utiliza el parámetro '$[0]' ya que la cadena de Trail viene con un formato de Array por lo que se necesita obtener el primer elemento de ese array
						-- La función JSON_MODIFY utiliza el parámetro 'append $' para indicar que se agregará como un elemento al final de la lista que contiene ese campo
						UPDATE Despachos.TicketsNoEntregados
							SET CausaCambioId = @CausaCambioId,
								Reintentos = @Reintentos,
								Restantes = @Restantes,
								Usuario = @Usuario,
								Trail = JSON_MODIFY(Trail, 'append $', JSON_QUERY(REPLACE(@Trail,'||--ACCION--||','Actualización de registro'), '$[0]'))
							WHERE Id = @IdTicketNoEntregado
						-- Confirma la actualización del registro
						SET @TotalRows = @IdTicketNoEntregado;
						SET @Message = 'Se actualizó el número de reintentos correctamente: ' +  CAST(@Reintentos AS VARCHAR(MAX)) + ' reintento(s), ' + CAST(@Restantes AS VARCHAR(MAX)) + ' restante(s)';
						COMMIT;
					END
			END TRY
			BEGIN CATCH
				-- Ha ocurrido un error al actualizar la información
				SET @ResponseCode = ERROR_NUMBER() * -1;
				SET @Message = ERROR_MESSAGE();
				-- Revierte el intento de la inserción
				ROLLBACK;
			END CATCH



    -- Insert statements for procedure here
	-- 3. Devuelve la información recopilada en la ejecución del script
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
							-- Información de los Despachos
							WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN '{"Id":' + CAST(@TotalRows AS VARCHAR(MAX)) + ',"Reintentos":' + CAST(@Reintentos AS VARCHAR(MAX)) + ',"Restantes":' + CAST(@Restantes AS VARCHAR(MAX)) + '}'
							-- No hay información para mostrar ya que ha ocurrido un error
							ELSE '[]' END						
					) +
				'}' AS JsonSalida;
END
GO
