USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspActualizarAppValidacionDespacho]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Diciembre de 2023
-- Description:	Establece el estatus del Despacho a través del Folio proporcionado con el estatus en un formato JSON : {"usuario":"Nombre del Usuario", "fecha":"Fecha de actualización", "estatus":"Correcto/Incorrecto"}
-- =============================================
CREATE PROCEDURE [Despachos].[uspActualizarAppValidacionDespacho]
	-- Add the parameters for the stored procedure here
	@FolioDespacho				VARCHAR(MAX) = NULL,
	@Validador					VARCHAR(MAX) = NULL
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
	-- Variables para analizar la información definida dentro del JSON
	DECLARE @JSON_Usuario		VARCHAR(MAX) = NULL;
	DECLARE @JSON_Estatus		VARCHAR(MAX) = NULL;
	DECLARE @JSON_Validador		VARCHAR(MAX) = NULL;


	-- Valida la información recibida como parámetros
	IF @FolioDespacho IS NULL OR @Validador IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible actualizar el Despacho porque no se han proporcionado los parámetros necesarios';
			GOTO SALIDA;			
		END
	ELSE
		BEGIN
			-- Determina si el despacho se encuentra registrado
			SELECT @TotalRows = COUNT(Id)
			FROM Despachos.Despachos
			WHERE FolioDespacho = @FolioDespacho
			-- Estatus donde el despacho ha sido confirmado o en proceso
			--AND EstatusId IN (2, 3)
			AND Eliminado = 1;

			-- El despacho no ha sido encontrado
			IF @TotalRows = 0
				BEGIN
					SET @ResponseCode = -2;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'El Despacho proporcionado no existe, no ha sido confirmado o ha sido eliminado';
					GOTO SALIDA;
				END
			-- Verifica que el parámetro que actualizará el campo Validador sea al menos una cadena JSON
			ELSE IF ISJSON(@Validador) = 0
				BEGIN
					SET @ResponseCode = -3;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'La cadena para actualizar el Despacho no tiene el formato válido';
					GOTO SALIDA;
				END
			-- Analiza la información contenida en el JSON
			ELSE
				BEGIN
					-- Recupera la información de cada pareja key/value del JSON pasado como parámetro
					SELECT
						@JSON_Usuario = usuario,
						@JSON_Estatus = estatus
					FROM OPENJSON (LOWER(@Validador))
						WITH
						(
							usuario		VARCHAR(MAX),
							estatus		VARCHAR(MAX)
						);

					-- No se ha encontrado el Usuario
					IF @JSON_Usuario IS NULL
						BEGIN
							SET @ResponseCode = -4;
							SET @TotalRows = @ResponseCode;
							SET @Message = 'El usuario dentro de la cadena JSON no ha sido definido';
							GOTO SALIDA;
						END
					-- No se ha encontrado el Estatus o no es válido
					ELSE IF @JSON_Estatus IS NULL OR (UPPER(@JSON_Estatus) <> 'POR VALIDAR' AND UPPER(@JSON_Estatus) <> 'CORRECTO' AND UPPER(@JSON_Estatus) <> 'INCORRECTO')
						BEGIN
							SET @ResponseCode = -6;
							SET @TotalRows = @ResponseCode;
							SET @Message = CASE
											WHEN @JSON_Estatus IS NULL THEN 'El estatus dentro de la cadena JSON no ha sido definida'
											ELSE UPPER(@JSON_Estatus) + ' no forma parte de los estatus establecidos' END;
							GOTO SALIDA;
						END
				END
		END


	-- Realiza la actualización de la información
		BEGIN TRY
			SET @JSON_Validador = '{'
									+
										'"usuario":"'	+ LOWER(@JSON_Usuario) + '",' +
										'"fecha":"'		+ CONVERT(VARCHAR, CURRENT_TIMESTAMP, 120) + '",' +
										'"estatus":"'	+ LOWER(@JSON_Estatus) + '"'
									+
								'}';
			UPDATE Despachos.Despachos
				SET Validador = @JSON_Validador
			WHERE FolioDespacho = @FolioDespacho
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
								SELECT JSON_QUERY((@JSON_Validador)) AS validador
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
