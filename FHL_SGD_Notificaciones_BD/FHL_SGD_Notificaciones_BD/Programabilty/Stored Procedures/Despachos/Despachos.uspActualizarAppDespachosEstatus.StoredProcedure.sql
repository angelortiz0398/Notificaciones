USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspActualizarAppDespachosEstatus]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Enero de 2024
-- Description:	Cambia el status del Despacho a partir del folio del mismo pasado como parámetro
--				Originalmente este SP está diseñado para iniciar el viaje una vez que se hayan recolectado todos los ticktes y se hayan validado correctamente,
--				es por eso que @EstatusId está definido con el valor 3 que indica que el viaje está en "Proceso", sin embargo, puede utilizarse para cambiar el estatus
--				según corresponda.
-- Estatus:
--				1 Borrador 
--				2 Confirmado
--				3 En proceso
--				4 Cerrado
--				5 Cancelado
--				6 Cancelado - En proceso
--				7 En riesgo
--				8 Error
-- =============================================
CREATE PROCEDURE [Despachos].[uspActualizarAppDespachosEstatus]
	-- Add the parameters for the stored procedure here
	@FolioDespacho					VARCHAR(MAX) = NULL,
	@EstatusId						BIGINT = 3
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode		INT = 0;
	DECLARE @Message			VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data				VARCHAR(MAX) = NULL;
	-- Número de registros afectados en la actualización
	DECLARE @TotalRows			INT = 0;
	--
	DECLARE @JsonResultado		VARCHAR(MAX) = NULL;


    -- Insert statements for procedure here
		IF @FolioDespacho IS NULL
			BEGIN
				-- No se estableció el Despacho para actualizar el estatus
				SET @ResponseCode = -1;
				SET @Message = 'No es posible actualizar el Estatus del Despachos porque no se ha proporcionado el folio';
				GOTO SALIDA;
			END
		ELSE
			BEGIN
				-- Determina si el Despacho existe y está vigente
				SELECT @TotalRows = COUNT(*) FROM Despachos.Despachos WHERE UPPER(RTRIM(LTRIM(FolioDespacho))) = UPPER(RTRIM(LTRIM(@FolioDespacho))) AND Eliminado = 1;
				IF  @TotalRows > 0
					BEGIN
						IF NOT @EstatusId BETWEEN 3 AND 8
							BEGIN
								-- El estatus no puede ser seleccionado para actualizar el Despacho
								SET @ResponseCode = -2;
								SET @Message = 'El despacho no puede ser actualizado con el estatus deseado';
								GOTO SALIDA;
							END
					END
				ELSE
					BEGIN
						-- El folio no existe y por lo tanto no puede realizarse la actualización del Estatus
						SET @ResponseCode = -3;
						SET @Message = 'No es posible actualizar el Estatus porque el Despacho no existe o ha sido eliminado';
						GOTO SALIDA;
					END
			END


	-- Realiza la actualización del Estatus del Despacho
		BEGIN TRY
			SET @JsonResultado = '{'
									+
										'"folioDespacho":"'	+ LOWER(@FolioDespacho) + '",' +
										'"estatusId":"'	+ CAST(@EstatusId AS VARCHAR(MAX))+ '"'
									+
								'}';
			UPDATE Despachos.Despachos
				SET EstatusId = @EstatusId
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
								SELECT JSON_QUERY(@JsonResultado) AS estatusDespacho
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
