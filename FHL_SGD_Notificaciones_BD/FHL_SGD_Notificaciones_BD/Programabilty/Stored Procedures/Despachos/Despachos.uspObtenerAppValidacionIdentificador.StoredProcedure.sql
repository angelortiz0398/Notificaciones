USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAppValidacionIdentificador]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Diciembre de 2023
-- Description:	Obtiene la información del @FolioIdentificador pasado como parámetro de acuerdo a la lista definida con el @TipoIdentificador
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAppValidacionIdentificador]
	-- Add the parameters for the stored procedure here
	@TipoIdentificador					INT				= NULL,
	@FolioIdentificador					VARCHAR(MAX)	= NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode				INT = 0;
	DECLARE @Message					VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data						VARCHAR(MAX) = NULL;
	-- Número de registros totales antes de la paginación
	DECLARE @TotalRows					INT = 0;
	-- Número de registros encontrados por cada tipo de Identificador
	DECLARE @TotalRowsByManifiesto		BIGINT = 0;
	DECLARE @TotalRowsByCortina			BIGINT = 0;
	DECLARE @TotalRowsByTicket			BIGINT = 0;
	DECLARE @TotalRowsBySello			BIGINT = 0;
	DECLARE @TotalRowsByVehiculo		BIGINT = 0;
	DECLARE @TotalRowsByColaborador		BIGINT = 0;
	DECLARE @TotalRowsByCustodio		BIGINT = 0;


    -- Valida la información recibida como parámetro
	IF @FolioIdentificador IS NULL OR @TipoIdentificador IS NULL
		BEGIN
			-- No se establecieron el tipo de objeto o el folio a validar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible validar la información ya está incompleta: no se ha proporcionado el folio y/o identificador o no se ha establecido el tipo de objeto a validar';
			GOTO SALIDA;			
		END
	-- Valida que el tipo de objeto a validar sea correcto
	ELSE IF NOT @TipoIdentificador BETWEEN 1 AND 7
		BEGIN
			-- No se establecieron el tipo de objeto o el folio a validar
			SET @ResponseCode = -2;
			SET @Message = 'No es posible validar la información ya que el tipo de objeto (' + CAST(@TipoIdentificador AS VARCHAR(MAX)) + ') no está definido actualmente';
			GOTO SALIDA;						
		END
	-- Valida que cuando sea Custodio, el @FolioIdentificador sea un numérico
	ELSE IF @TipoIdentificador = 7 AND ISNUMERIC(@FolioIdentificador) = 0
		BEGIN
			-- No se establecieron el tipo de objeto o el folio a validar
			SET @ResponseCode = -3;
			SET @Message = 'No es posible validar la información ya que se necesita el Identificador del Custudio';
			GOTO SALIDA;						
		END



	-- Devuelve la información recopilada en la ejecución del script
	SALIDA:
		--set @ResponseCode = 1;
		--set @TotalRows = 1;
		-- Determina cuantos elementos va a encontrar
		IF @ResponseCode >= 0 AND @TipoIdentificador BETWEEN 1 AND 7
			BEGIN
				IF @TipoIdentificador = 1
					BEGIN
						SELECT @TotalRowsByManifiesto = COUNT(*) FROM Despachos.Despachos Despachos WHERE UPPER(FolioDespacho) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByManifiesto;
					END
				IF @TipoIdentificador = 2
					BEGIN
						SELECT @TotalRowsByCortina = COUNT(*) FROM Despachos.Andenes Andenes WHERE UPPER(Andenes.CodigoAnden) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByCortina;
					END
				IF @TipoIdentificador = 3
					BEGIN
						SELECT @TotalRowsByTicket = COUNT(*) FROM Despachos.Tickets Tickets WHERE UPPER(Tickets.FolioTicket) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByTicket;
					END
				IF @TipoIdentificador = 4
					BEGIN
						SELECT @TotalRowsBySello = COUNT(*) FROM Despachos.Sellos Sello WHERE UPPER(Sello.Sello) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsBySello;
					END
				IF @TipoIdentificador = 5
					BEGIN
						SELECT @TotalRowsByVehiculo = COUNT(*) FROM Vehiculos.Vehiculos Vehiculos WHERE UPPER(Vehiculos.VIN) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByVehiculo;
					END
				IF @TipoIdentificador = 6
					BEGIN
						SELECT @TotalRowsByColaborador = COUNT(*) FROM Operadores.Colaboradores Colaboradores WHERE UPPER(Colaboradores.RFC) = UPPER(@FolioIdentificador) AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByColaborador;
					END
				IF @TipoIdentificador = 7
					BEGIN
						SELECT @TotalRowsByCustodio = COUNT(*) FROM Despachos.Custodias Custodias WHERE Custodias.Id = @FolioIdentificador AND Eliminado = 1;
						SET @TotalRows = @TotalRowsByCustodio;
					END
			END
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
						WHEN @ResponseCode >= 0 AND @TotalRows >= 0 THEN
							(
								SELECT
									-- Tipo de Objeto
									@TipoIdentificador AS TipoObjetoId,
									(
										CASE
											WHEN @TipoIdentificador = 1 THEN 'Manifiesto - Despacho'
											WHEN @TipoIdentificador = 2 THEN 'Cortina - Anden'
											WHEN @TipoIdentificador = 3 THEN 'Ticket'
											WHEN @TipoIdentificador = 4 THEN 'Sello'
											WHEN @TipoIdentificador = 5 THEN 'Vehículo'
											WHEN @TipoIdentificador = 6 THEN 'Colaborador'
											WHEN @TipoIdentificador = 7 THEN 'Custodio'
											ELSE 'No definido' END
									) AS TipoObjeto,
									-- Detalle del Objeto 1: 'Manifiesto/Despacho'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 1 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByManifiesto > 0 THEN
															(
																SELECT
																	Despachos.Id,
																	Despachos.FolioDespacho,
																	Despachos.Origen,
																	Despachos.Destino,
																	Despachos.FechaCreacion
																FROM Despachos.Despachos Despachos
																WHERE UPPER(FolioDespacho) = UPPER(@FolioIdentificador)
																AND Despachos.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Manifiesto,
									-- Detalle del Objeto 2: 'Cortina - Anden'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 2 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByCortina > 0 THEN
															(
																SELECT
																	Andenes.Id,
																	Andenes.Nombre,
																	Andenes.CodigoAnden
																FROM Despachos.Andenes Andenes
																WHERE UPPER(Andenes.CodigoAnden) = UPPER(@FolioIdentificador)
																AND Andenes.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Anden,
									-- Detalle del Objeto 3: 'Ticket'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 3 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByTicket > 0 THEN
															(
																SELECT
																	Tickets.Id,
																	Tickets.FolioTicket,
																	Tickets.Comentarios
																FROM Despachos.Tickets Tickets
																WHERE UPPER(Tickets.FolioTicket) = UPPER(@FolioIdentificador)
																AND Tickets.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Ticket,
									-- Detalle del Objeto 4: 'Sello'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 4 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsBySello > 0 THEN
															(
																SELECT
																	Sello.Id,
																	Sello.Sello
																FROM Despachos.Sellos Sello
																WHERE UPPER(Sello.Sello) = UPPER(@FolioIdentificador)
																AND Sello.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Sello,
									-- Detalle del Objeto 5: 'Vehículo'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 5 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByVehiculo > 0 THEN
															(
																SELECT
																	Vehiculos.Id,
																	Vehiculos.Economico,
																	Vehiculos.Placa,
																	Vehiculos.VIN
																FROM Vehiculos.Vehiculos Vehiculos
																WHERE UPPER(Vehiculos.VIN) = UPPER(@FolioIdentificador)
																AND Vehiculos.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													-- Tipo de Objeto no seleccionado en la ejecución
													'[]'
												END
										)
									) AS Vehiculo,
									-- Detalle del Objeto 6: 'Colaborador'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 6 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByColaborador > 0 THEN
															(
																SELECT
																	Colaboradores.Id,
																	Colaboradores.CorreoElectronico,
																	Colaboradores.Nombre,
																	Colaboradores.RFC
																FROM Operadores.Colaboradores Colaboradores
																WHERE UPPER(Colaboradores.RFC) = UPPER(@FolioIdentificador)
																AND Colaboradores.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Colaborador,
									-- Detalle del Objeto 7: 'Custodio'
									JSON_QUERY
									(
										(
											CASE
												WHEN @TipoIdentificador = 7 THEN
													(
														-- Determina cuantos elementos cumplen con el criterio de búsqueda
														CASE WHEN @TotalRowsByCustodio > 0 THEN
															(
																SELECT
																	Custodias.Id,
																	Custodias.NombreCustodio,
																	Custodias.NumeroTelefono,
																	Custodias.PlacasVehiculo,
																	Custodias.DespachoId
																FROM Despachos.Custodias Custodias
																WHERE Custodias.Id = @FolioIdentificador
																AND Custodias.Eliminado = 1
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														ELSE
															-- No existen elementos que cumplna con el criterio de búsqueda
															'[]'
														END
													)
												ELSE
													'[]'
												END
										)
									) AS Custodio
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
