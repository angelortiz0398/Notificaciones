USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerAppChecklistByVehiculo]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Enero de 2024
-- Description:	Obtiene el checklist especifico que aplica para un vehículo específico
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspObtenerAppChecklistByVehiculo]
	-- Add the parameters for the stored procedure here
	@VehiculoId					BIGINT = NULL,
	@ChecklistId				BIGINT = NULL
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
	-- Crea una tabla variable para depositar la ifnroamción del Checklist y la información del Vehículo
	DECLARE @InfoVehiculoVsChecklist TABLE(
		Id						BIGINT,
		Periodicidad			VARCHAR(MAX),
		FechaInicio				DATETIME,
		ChecklistId				BIGINT,
		CheckList				VARCHAR(MAX)
	)

	-- Valida la información recibida como parámetro
	IF @VehiculoId IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible consultar los checklist por vehículo ya que no se ha(n) proporcionado el(los) datos necesarios';
			GOTO SALIDA;
		END
	ELSE
		BEGIN
			DECLARE @PreguntasRespuestas TABLE (
				JsonSalida VARCHAR(MAX)
			);

			-- Obtiene la lista de Preguntas y Respuestas
			IF @ChecklistId IS NOT NULL
				BEGIN
					INSERT INTO @PreguntasRespuestas
						EXEC [Checklist].[uspObtenerPreguntasConRespuestas] @IdChecklist = @ChecklistId;
				END;


			-- Obtiene la información del Checklist y el Vehículo de acuerdo a los parámetros pasados como parámetro
			INSERT INTO @InfoVehiculoVsChecklist
				SELECT
					C_V.Id,
					C_V.Periodicidad,
					C_V.FechaInicio,
					C_V.ChecklistId,
					(
						JSON_QUERY
						(
							(
								-- Información la lista de Checklist
								SELECT
									C_L.Id,
									C_L.Nombre,
									C_L.PonderacionMaxima,
									C_L.FechaVencimiento,
									JSON_QUERY(C_L.CorreosNotificacion) AS CorreosNotificacion,
									C_L.QuienEjecuta,
									JSON_QUERY((SELECT * FROM @PreguntasRespuestas)) AS Preguntas
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						)
					)
				FROM Vehiculos.Checkslist C_V
				INNER JOIN Vehiculos.Vehiculos V
					ON V.Id = C_V.VehiculoId
					AND V.Eliminado = 1
				INNER JOIN Checklist.CheckList C_L
					ON C_L.Id = C_V.CheckListId
					AND C_L.Eliminado = 1
				WHERE C_V.VehiculoId = @VehiculoId
					AND	(@ChecklistId IS NULL OR C_V.CheckListId = @ChecklistId)
					AND C_V.Eliminado = 1;
			--SELECT * FROM @InfoVehiculoVsChecklist;


			-- Determina cuantos elementos fueron encontrados
			SELECT @TotalRows = COUNT(Id) FROM @InfoVehiculoVsChecklist;


			IF @TotalRows = 0
				BEGIN
					SET @ResponseCode = -2;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'El Vehículo y/o checklist proporcionado no ha sido definido o ha sido eliminado';
					GOTO SALIDA;
				END
		END


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
						WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN
							(
								SELECT
									@VehiculoId AS VehiculoId,
									(
										JSON_QUERY
										(
											(
												-- Información del Vehiculo
												SELECT
													V.Id,
													V.Placa,
													V.Economico,
													V.VIN
												FROM Vehiculos.Vehiculos V
												WHERE V.Id = @VehiculoId
												AND V.Eliminado = 1
												FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
											)
										)
									) AS Vehiculo,
									(
										JSON_QUERY
										(
											(
												SELECT
													Id,
													-- https://stackoverflow.com/questions/60841198/using-both-scalar-values-and-json-objects-as-json-values
													-- Genera 2 posibles valores (valor escalar o un objeto anidado) y al final devuelve el que tenga valor
													-- Importante utilizar FOR JSON AUTO
													JSON_VALUE(Periodicidad, '$.Periodicidad') AS Periodicidad,
													JSON_QUERY(Periodicidad, '$.Periodicidad') AS Periodicidad,
													FechaInicio,
													ChecklistId,
													JSON_QUERY(Checklist) AS Checklist
												FROM @InfoVehiculoVsChecklist C_V
												FOR JSON AUTO
											)
										)
									) AS VehiculoVsChecklist
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						-- Se devuelve "" por tratarse solo de un Objeto aunque internamente tenga una lista
						ELSE '""' END						
				) +
			'}' AS JsonSalida;
END
GO
