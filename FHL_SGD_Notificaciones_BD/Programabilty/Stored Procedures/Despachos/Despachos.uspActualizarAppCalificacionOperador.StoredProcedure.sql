USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspActualizarAppCalificacionOperador]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Enero de 2024
-- Description:	Establece la calificación del Operador con máximo 5 estrellas de calificación
-- =============================================
CREATE PROCEDURE [Despachos].[uspActualizarAppCalificacionOperador]
	-- Add the parameters for the stored procedure here
	@FolioDespacho				VARCHAR(MAX)	= NULL,
	@OperadorId					BIGINT			= NULL,
	@EncuestaOperadorPickUp		INT				= NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode		INT = 0;
	DECLARE @Message			VARCHAR(MAX) = 'Actualización completada correctamente';
	DECLARE @Data				VARCHAR(MAX) = NULL;
	-- Número de registros afectados en la actualización
	DECLARE @TotalRows			INT = 0;
	DECLARE @OperadorValido		BIT = 0;
	-- Variables para analizar la información definida dentro del JSON
	DECLARE @JSON_Usuario		VARCHAR(MAX) = NULL;
	DECLARE @JSON_Fecha			DATETIME = NULL;
	DECLARE @JSON_Estatus		VARCHAR(MAX) = NULL;
	DECLARE @JSON_Validador		VARCHAR(MAX) = NULL;


	-- Valida la información recibida como parámetros
	IF @FolioDespacho IS NULL OR @OperadorId IS NULL OR @EncuestaOperadorPickUp IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible actualizar la calificación del Operador porque no se han proporcionado los parámetros necesarios';
			GOTO SALIDA;			
		END
	ELSE
		BEGIN
			-- Determina si el despacho se encuentra registrado junto con el operador asignado
			SELECT @TotalRows = COUNT(*) FROM Despachos.Despachos
			WHERE FolioDespacho = @FolioDespacho
			AND OperadorId = @OperadorId
			AND Eliminado = 1;

			-- Determina si el Operador se encuentra registrado y activo
			SELECT @OperadorValido =
				(
					CASE
						WHEN COUNT(*) > 0 THEN 1
						ELSE 0 END
				)
			FROM Operadores.Colaboradores
			WHERE Id = @OperadorId
				AND Eliminado = 1
				-- No existe un catálogo definido para identificar Operadores por lo cual se elimina el Perfil
				--AND TipoPerfilesId = 1

			-- El Despacho y/o el Operador no ha sido encontrado
			IF @TotalRows = 0 OR @OperadorValido = 0
				BEGIN
					IF @TotalRows = 0
						BEGIN
							SET @ResponseCode = -2;
							SET @TotalRows = @ResponseCode;
							SET @Message = 'El folio del Despacho proporcionado no existe o ha sido eliminado';
							GOTO SALIDA;
						END
					ELSE
						BEGIN
							SET @ResponseCode = -3;
							SET @TotalRows = @ResponseCode;
							SET @Message = 'El Operador a calificar no existe o ha sido eliminado';
							GOTO SALIDA;
						END
				END

			-- Determina si la calificación está dentro de los rangos establecidos
			IF NOT @EncuestaOperadorPickUp BETWEEN 1 AND 5
				BEGIN
					SET @ResponseCode = -4;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'La calificación debe estar entre el rango de 1 a 5 estrellas';
					GOTO SALIDA;
				END
		END



	-- Realiza la actualización de la calificación del Operador
		BEGIN TRY
			UPDATE Despachos.Despachos
				SET EncuestaOperadorPickup = @EncuestaOperadorPickUp
			WHERE FolioDespacho = @FolioDespacho
				AND OperadorId = @OperadorId
				AND Eliminado = 1;
		END TRY
		BEGIN CATCH
			-- Ha ocurrido un error al actualizar la información
			SET @ResponseCode = ERROR_NUMBER() * -1;
			SET @Message = ERROR_MESSAGE();
		END CATCH



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
						WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN
							(
								'{"encuestaOperadorPickup":"' + CAST(@EncuestaOperadorPickUp AS VARCHAR(1)) + ' estrella(s)"}'
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
