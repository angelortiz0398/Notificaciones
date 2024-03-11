USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAppDespachosByOperador]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Octubre de 2023
-- Description:	Obtiene la lista general de Despachos (Manifiesto) ligado al Usuario pasado como parámetro
-- =============================================
-- Parameters:	@OperadorId		=> Identificador del Operador que hace la consulta (Requerido)
--				@FolioDespacho	=> Folio del Desapcho (Opcional)
--				@OrigenConsulta	=> Origen de la consulta (Opcional).
--										Cuando no se especifica entonces se tratarán de Manifiestos que se deben atender en el día de hoy
--				@FechaInicial	=> Fecha inicial de consulta (Opcional)
-- =============================================
-- Lista de Status a considerar:
--				1 => Borrador 
--				2 => Confirmado
--				3 => En proceso
--				4 => Cerrado
--				5 => Cancelado
--				6 => Cancelado - En proceso
--				7 => En riesgo
--				8 => Error
-- =============================================

CREATE PROCEDURE [Despachos].[uspObtenerAppDespachosByOperador]
	-- Definición de parámetros de entrada
	@OperadorId					BIGINT			= NULL,
	@FolioDespacho				VARCHAR(20)		= NULL,
	@OrigenConsulta				VARCHAR(MAX)	= NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode		INT = 0;
	DECLARE @Message			VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data				VARCHAR(MAX) = NULL;
	DECLARE @EstatusValidacion	VARCHAR(MAX) = '{"estatus":"por validar"}';
	-- Estatus validos para indicar los Despachos que tiene que atender el Operador. Utilizado normalmente para la lista de Manifiestos que tiene que atender el Operador.
	DECLARE @EstatusValidosXAtender		VARCHAR(MAX) = '2,3';
	-- Número de registros totales antes de la paginación
	DECLARE @TotalRows			INT = 0;
	-- Fecha Inicial de consulta
	DECLARE @FechaInicial		DATE = CURRENT_TIMESTAMP;
	-- Tabla variable para el manejo de la información
	DECLARE @CteDespachos TABLE(
		Id						BIGINT,
		FolioDespacho			VARCHAR(20),
		Origen					VARCHAR(500),
		Destino					VARCHAR(500),
		VehiculoId				BIGINT,
		OperadorId				BIGINT,
		EstatusId				BIGINT,
		FechaSalida				DATETIME,
		OcupacionEfectiva		VARCHAR(20),
		TiempoEntrega			VARCHAR(30),
		Validador				VARCHAR(500),
		FechaLlegada			DATETIME
	)

	-- Determina el período de tiempo para realizar la consulta
	IF UPPER(@OrigenConsulta) = 'GASTOS_OPERATIVOS'
		BEGIN
			-- Se necesitan los Despachos para revisar gastos operativos y no se especifica la fecha inicial de consulta
			SET @FechaInicial = DATEADD(DAY, -30, @FechaInicial);
		END


    -- Valida la información recibida como parámetro
	IF @OperadorId IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible consultar los despachos porque no se ha proporcionado el Identificador del Operador';
			GOTO SALIDA;			
		END


	-- Recupera la información de los Despachos
	INSERT INTO @CteDespachos
		SELECT DISTINCT
			D.Id,
			D.FolioDespacho,
			D.Origen,
			D.Destino,
			D.VehiculoId,
			D.OperadorId,
			D.EstatusId,
			(
				SELECT TOP(1) FechaSalida
				FROM Despachos.Visores D_V
				WHERE D_V.ManifiestoId = D.Id
				AND D_V.Eliminado = 1
			),
			D.OcupacionEfectiva,
			D.TiempoEntrega,
			(
				CASE
					WHEN D.Validador IS NULL THEN @EstatusValidacion
					ELSE D.Validador END
			),
			-- Fecha de Retorno a nivel de Ticket
			(
				SELECT MAX(D_V.FechaRetorno)
				FROM Despachos.Visores D_V
				WHERE D_V.ManifiestoId = D.Id
				AND D_V.Eliminado = 1
			)
			FROM Despachos.Despachos D
			-- Filtros
			WHERE D.OperadorId = @OperadorId
				-- Despacho confirmado
				AND D.Borrador = 0
				-- Registros activos
				AND D.Eliminado = 1
				-- Lista de Estatus considerados (ACTIVAR CUANDO SEA PRODUCTIVO)
				AND (
						D.EstatusId IN
						(
								SELECT CAST(value AS INT) AS Id
								FROM STRING_SPLIT(@EstatusValidosXAtender, ',')
								WHERE @OrigenConsulta IS NULL
							UNION ALL
								SELECT D.EstatusId
								WHERE @OrigenConsulta IS NOT NULL
						)
					)
				-- Rango de fechas (Día completo actual) (ACTIVAR CUANDO SEA PRODUCTIVO)
				AND	(
						--D.FechaCreacion >= @FechaInicial
						D.FechaCreacion >= D.FechaCreacion
						AND
						D.FechaCreacion < DATEADD(DAY, 1, CAST(CURRENT_TIMESTAMP AS DATE))
					)
				-- Folio del Despacho (OPCIONAL)
				AND (
						@FolioDespacho IS NULL
						OR
						D.FolioDespacho = @FolioDespacho
					);


	-- Determina el número de registros principales encontrados (Despachos)
	SELECT @TotalRows = COUNT(*) FROM @CteDespachos;

	-- Devuelve la información recopilada en la ejecución del script
	SALIDA:
		-- Determina si debe mostrar el número de registros encontrados o el error generado
		IF @ResponseCode >= 0
			BEGIN
				-- Establece el número de filas encontradas con los criterios en base a los parámetros pasados como parámetro
				SET @ResponseCode = @TotalRows

				-- Marca los Despachos que fueron consultados como primera vez
				UPDATE Despachos
					SET Validador = @EstatusValidacion
				FROM Despachos.Despachos Despachos
					INNER JOIN @CteDespachos CteDespachos
					ON CteDespachos.Id = Despachos.Id
				--WHERE Despachos.Validador IS NULL
			END
		ELSE
			BEGIN
				-- Ha ocurrido un error al consultar ya que no se han pasado los parametros correctos
				SET @TotalRows = @ResponseCode;
			END

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
									Despacho.Id,
									Despacho.FolioDespacho,
									Despacho.Origen,
									Despacho.Destino,
									-- Info del Operador
									Despacho.OperadorId,
										JSON_QUERY
										(
											(
												SELECT
													Op.Id,
													Op.Nombre,
													Op.RFC
												FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
											)
										) AS Operador,
									-- Estatus
									Despacho.EstatusId,
									JSON_QUERY
									(
										(
											SELECT
												Id = Despacho.EstatusId,
												Nombre =
													CASE
														WHEN Despacho.EstatusId = 1 THEN 'Borrador'
														WHEN Despacho.EstatusId = 2 THEN 'Confirmado'
														WHEN Despacho.EstatusId = 3 THEN 'En proceso'
														WHEN Despacho.EstatusId = 4 THEN 'Cerrado'
														WHEN Despacho.EstatusId = 5 THEN 'Cancelado'
														WHEN Despacho.EstatusId = 6 THEN 'Cancelado - En proceso'
														WHEN Despacho.EstatusId = 7 THEN 'En riesgo'
														WHEN Despacho.EstatusId = 8 THEN 'Error'
														ELSE 'Desconocido' END
											FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
										)
									) AS Estatus,
									-- Fecha de salida del viaje
									(
										CASE
											WHEN Despacho.FechaSalida IS NOT NULL THEN CONVERT(VARCHAR(MAX), Despacho.FechaSalida, 126)
											ELSE '[]' END
									) AS FechaSalida,
									-- Fecha de retorno del viaje
									(
										CASE
											WHEN Despacho.FechaLlegada IS NOT NULL THEN CONVERT(VARCHAR(MAX), Despacho.FechaLlegada, 126)
											ELSE '[]' END
									) AS FechaLlegada,
									--
									Despacho.OcupacionEfectiva,
									Despacho.TiempoEntrega,
									-- Validador com un JSON
										JSON_QUERY
										(
											(
												SELECT Despacho.Validador
											)
										) AS Validador,
									-- Info de Vehiculos
										Despacho.VehiculoId,
										JSON_QUERY
										(
											(
												SELECT
													V.Id,
													V.Placa,
													V.Economico,
													V.VIN,
													V.TanqueCombustible,
													V.Anio,
													-- Marca
														V.MarcaId,
														JSON_QUERY
														(
															(
																SELECT
																	Mca.Id,
																	Mca.Nombre
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														) AS Marca,
													-- Modelo
														V.ModeloId,
														JSON_QUERY
														(
															(
																SELECT
																	Modelos.Id,
																	Modelos.Nombre,
																	Modelos.MarcaId
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														) AS Modelo
												FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
											)
										) AS Vehiculo,
										-- Gastos Operativos
										(
											SELECT
											(
												JSON_QUERY
												(
													(
														SELECT
															Gasto.TipoGastoId,
															(
																JSON_QUERY
																(
																	(
																		SELECT
																			Gasto.TipoGastoId AS Id,
																			TipoGasto.Nombre
																			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
																	)
																)		
															) AS TipoGasto,
															-- Gastos Registrados
															(
																JSON_QUERY
																(
																	(
																		SELECT
																			Gasto.Id,
																			Gasto.MonedaIdMonto,
																			(
																				JSON_QUERY
																				(
																					(
																						SELECT
																							Gasto.MonedaIdMonto AS Id,
																							(
																								CASE
																									WHEN Gasto.MonedaIdMonto = 1 THEN 'Peso Mexicano'
																									WHEN Gasto.MonedaIdMonto = 2 THEN 'Dolar Estadounidense' END
																							) AS Nombre
																							FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
																					)
																				)
																			) AS Moneda,
																			Gasto.Monto
																		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
																	)
																)
															) AS GastoDispersion,
															--
															(
																JSON_QUERY
																(
																	(
																		SELECT
																			Liquidacion.Id,
																			Liquidacion.MonedaIdMonto,
																			(
																				CASE
																					WHEN Liquidacion.MonedaIdMonto IS NOT NULL THEN
																						(
																							JSON_QUERY
																							(
																								(
																									SELECT
																										Liquidacion.MonedaIdMonto AS Id,
																										(
																											CASE
																												WHEN Liquidacion.MonedaIdMonto = 1 THEN 'Peso Mexicano'
																												WHEN Liquidacion.MonedaIdMonto = 2 THEN 'Dolar Estadounidense' END
																										) AS Nombre
																										FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
																								)
																							)
																						)
																					END
																			) AS Moneda,
																			Liquidacion.Monto
																		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
																	)
																)
															) AS GastoLiquidado
														FROM Despachos.RegistrosDispersiones Gasto
														INNER JOIN Despachos.TipoGastos TipoGasto
															ON TipoGasto.Id = Gasto.TipoGastoId
														INNER JOIN Operadores.Colaboradores Colaborador
															ON Colaborador.Id = Gasto.ColaboradorId
														LEFT JOIN Despachos.RegistrosLiquidaciones Liquidacion
															ON Liquidacion.ColaboradorId = Gasto.ColaboradorId
															AND Liquidacion.DespachoId = Gasto.DespachoId
															AND Liquidacion.TipoGastoId = Gasto.TipoGastoId
														WHERE
															Gasto.Eliminado = 1
															AND Gasto.ColaboradorId = Despacho.OperadorId
															AND Gasto.DespachoId = Despacho.Id
														FOR JSON PATH
													)
												)
											) 
										) AS GastosOperativos
								FROM @CteDespachos Despacho
								-- Vehículos
								LEFT JOIN Vehiculos.Vehiculos V
									ON V.Id = Despacho.VehiculoId
								-- Marca de Vehículos
								LEFT JOIN Vehiculos.Marcas Mca
									ON Mca.Id = V.MarcaId
								-- Modelos de Vehículos
								LEFT JOIN Vehiculos.Modelos Modelos
									ON Modelos.Id = V.ModeloId
								-- Colaboradores
								LEFT JOIN Operadores.Colaboradores Op
									ON Op.Id = Despacho.OperadorId
								FOR JSON PATH
							)

						-- No hay información para mostrar ya que ha ocurrido un error
						ELSE '[]' END
				) +
			'}' AS JsonSalida;
END
GO
