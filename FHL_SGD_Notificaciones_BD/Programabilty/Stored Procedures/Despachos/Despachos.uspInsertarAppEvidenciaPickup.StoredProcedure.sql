USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarAppEvidenciaPickup]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Enero de 2024
-- Description:	Inserta la información de las Evidencias al levantar el Pickup
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarAppEvidenciaPickup]
	-- Add the parameters for the stored procedure here
	@FolioObjeto				VARCHAR(MAX) = NULL,
	@Nombre						VARCHAR(50) = NULL,
	@Extension					VARCHAR(10) = NULL,
	@DocumentoId				INT = NULL,
	@TipoEvidencia				INT = NULL,
	@FlujoId					INT = NULL,
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
	-- Número de registros totales antes de la paginación
	DECLARE @TotalRows			INT = 0;
	-- Identificador del Ticket
	DECLARE @TicketId			BIGINT = NULL;


	-- Valida que este completa la información
	IF	(@FolioObjeto IS NULL OR NULLIF(LTRIM(RTRIM(@FolioObjeto)), '') IS NULL) OR
		(@Nombre IS NULL OR NULLIF(LTRIM(RTRIM(@Nombre)), '') IS NULL) OR
		(@Extension IS NULL OR NULLIF(LTRIM(RTRIM(@Extension)), '') IS NULL) OR
		@DocumentoId IS NULL OR @TipoEvidencia IS NULL OR @FlujoId IS NULL OR
		(@Usuario IS NULL OR NULLIF(LTRIM(RTRIM(@Usuario)), '') IS NULL) OR
		(@Trail IS NULL OR NULLIF(LTRIM(RTRIM(@Trail)), '') IS NULL)
		BEGIN
			-- La información a guardar está incompleta
			SET @ResponseCode = -1;
			SET @Message = 'No es posible guardar la evidencia ya que se ha proporcionado la información necesaria';
			GOTO SALIDA;
		END

	-- Valida que el Folio del Objeto proporcionado sea válido
	IF @FolioObjeto IS NOT NULL AND NULLIF(LTRIM(RTRIM(@FolioObjeto)), '') IS NOT NULL
		BEGIN
			-- Determina si el Ticket se encuentra registrado
			SELECT
				@TicketId = Tickets.Id,
				@TotalRows = COUNT(Tickets.Id)
			FROM Despachos.Tickets Tickets
			INNER JOIN Despachos.TicketsAsignados TicketsAsignados
				ON TicketsAsignados.TicketId = Tickets.Id
				AND TicketsAsignados.Eliminado = 1
			INNER JOIN Despachos.Despachos Despachos
				ON Despachos.Id = TicketsAsignados.DespachoId
				AND Despachos.Eliminado = 1
				AND Borrador = 0
			WHERE Tickets.FolioTicket = @FolioObjeto
			AND Tickets.Eliminado = 1
			GROUP BY Tickets.Id;

			-- No se ha encontrado el folio del objeto
			IF @TotalRows <> 1
				BEGIN
					SET @ResponseCode = -2;
					SET @Message = CASE
									WHEN @TotalRows < 1 THEN 'El folio del Objeto proporcionado no existe o ha sido eliminado o no ha sido usado'
									ELSE 'El folio del Objeto proporcionado está ligado a ' + CAST(@TotalRows AS VARCHAR(MAX)) + ' Despachos diferentes' END;
					GOTO SALIDA;
				END
		END

	-- Valida que el tipo de Evidencia sea válido
	IF NOT @TipoEvidencia BETWEEN 1 AND 3
		BEGIN
			SET @ResponseCode = -3;
			SET @Message = 'El Tipo de Evidencia \"' + CAST(@TipoEvidencia AS VARCHAR(MAX)) + '\" propocionado no está dentro de los Tipos válidos definidos';
			GOTO SALIDA;
		END

	-- Valida que la cadena Trail sea un JSON válido
	IF ISJSON(@Trail) = 0
		BEGIN
			SET @ResponseCode = -4;
			SET @Message = 'La información que contiene datos de la inserción en el campo Trail no tiene el formato json correcto';
			GOTO SALIDA;			
		END

	-- Valida que el Identificador del Flujo sea válido
	IF NOT @FlujoId BETWEEN 1 AND 3
		BEGIN
			SET @ResponseCode = -5;
			SET @Message = 'El Flujo de Evidencia \"' + CAST(@FlujoId AS VARCHAR(MAX)) + '\" propocionado no está dentro de los Flujos válidos definidos';
			GOTO SALIDA;			
		END



	-- Inserta la información en la tabla correspondiente
	BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO Despachos.EvidenciasTickets(
				TicketId,
				Nombre,
				Extension,
				DocumentoId,
				TipoEvidencia,
				FlujoId,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			) VALUES (
				@TicketId,
				@Nombre,
				@Extension,
				@DocumentoId,
				@TipoEvidencia,
				@FlujoId,
				@Usuario,
				1,
				CURRENT_TIMESTAMP,
				@Trail
			);

			-- Recupera el Identificador con el cual se guardó el registro
			SET @TotalRows = SCOPE_IDENTITY();
			-- Confirma la inserción
			COMMIT;
		END TRY

		BEGIN CATCH
			-- Ha ocurrido un error al actualizar la información
			SET @ResponseCode = ERROR_NUMBER() * -5;
			SET @Message = ERROR_MESSAGE();
			-- Revierte el intento de la inserción
			ROLLBACK;
		END CATCH


    -- Insert statements for procedure here
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
						-- Información de los Despachos
						WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN '{"EvidenciaId":' + CAST(@TotalRows AS VARCHAR(MAX)) + ',"DocumentoId":' + CAST(@DocumentoId AS VARCHAR(MAX)) + ',"Nombre":"' + @Nombre + '","Extension":"' + @Extension + '"}'
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END						
				) +
			'}' AS JsonSalida;
END
GO
