USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspInsertarVehiculos]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Inserta una lista de vehículos pasados como parámetros como formato JSON en una carga masiva
--				Devuelve un número positivo en caso de éxito o negativo en caso de error así como las estadísticas de la ejecución del script
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspInsertarVehiculos]
	-- Add the parameters for the stored procedure here
	@ListaVehiculosJson					VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Variables de salida al ejecutar el SP y manejo de estadísticas
	DECLARE @Resultado					INT = 0;
	DECLARE @Mensaje					VARCHAR(MAX) = NULL;
	DECLARE @NumRegistrosTotales		INT = 0;				-- Indica cuantos registros totales fueron pasados en la cadena JSON de entrada
	DECLARE @NumRegistrosInsertados		INT = 0;				-- Indica cuantos registros fueron insertados correctamente en la tabla correspondiente
	DECLARE @DetalleMensajesError		VARCHAR(MAX) = NULL;	-- Recupera la lista de errores en cada registro


	-- 1. Crea una tabla temporal para guardar la información provieniente de la cadena JSON pasada como parámetro
		CREATE TABLE #TablaTmp(
			Linea						INT NOT NULL IDENTITY(2,1),	-- En el archivo CSV los datos inician en la línea 2 ya que la primera línea pertenece a los encabezados
			Id							INT DEFAULT 0, -- Identificador que se actualizará al momento de realizar la inserción de la información de cada registro
			-- Campos no duplicables
			Placa						VARCHAR(50),
			Economico					VARCHAR(150),
			Vin							VARCHAR(50),
			-- Identificadores de llaves foraneas y textos originales en el JSON
			-- Marca
			MarcaId						BIGINT,
			Marca						VARCHAR(200),
			-- Modelo
			ModeloId					BIGINT,
			Modelo						VARCHAR(200),
			-- Color
			ColorId						BIGINT,
			Color						VARCHAR(150),
			-- Tipo de Combustible
			TipoCombustibleId			BIGINT,
			TipoCombustible				VARCHAR(150),
			-- Esquema
			EsquemaId					BIGINT,
			Esquema						VARCHAR(150),
			-- Proveedor de seguro
			ProveedorSeguroId			BIGINT,
			ProveedorSeguro				VARCHAR(500),
			-- Configuración
			ConfiguracionId				BIGINT,
			Configuracion				VARCHAR(150),
			-- Proveedor
			ProveedorId					BIGINT,
			Proveedor					VARCHAR(500),
			-- Tipo de Vehículo
			TipoId						BIGINT,
			Tipo						VARCHAR(150),
			-- Operador predeterminado
			ColaboradorId				BIGINT,
			Colaborador					VARCHAR(500),
			-- Textos que deberán ser convertidos a un formato JSON
				-- ==== Grupo de Vehículos ====
				GrupoVehiculo				VARCHAR(3000),
				GrupoVehiculo_JSON			VARCHAR(3000),
				GrupoVehiculoRecibidos		INT DEFAULT 0,
				GrupoVehiculoValidados		INT DEFAULT 0,
				-- ==== Unidades de Negocio ====
				UN							VARCHAR(5000),
				UN_JSON						VARCHAR(5000),
				UNRecibidos					INT DEFAULT 0,
				UNValidados					INT DEFAULT 0,
				-- ==== Habilidades ====
				HabilidadVehiculos			VARCHAR(5000),
				HabilidadVehiculos_JSON		VARCHAR(5000),
				HabilidadVehiculosRecibidos	INT DEFAULT 0,
				HabilidadVehiculosValidados	INT DEFAULT 0,
				-- ==== Rangos de Operación ====
				RangoOperacion				VARCHAR(3000),
				RangoOperacion_JSON			VARCHAR(3000),
				RangoOperacionRecibidos		INT DEFAULT 0,
				RangoOperacionValidados		INT DEFAULT 0,
			-- Campos complementarios
			Anio						INT,
			TanqueCombustible			INT,
			RendimientoMixto			DECIMAL,
			RendimientoUrbano			DECIMAL,
			RendimientoSuburbano		DECIMAL,
			CapacidadVolumen			INT,
			CapacidadVolumenEfectivo	INT,
			Factura						VARCHAR(150),
			FacturaCarrocero			VARCHAR(150),
			PolizaSeguro				VARCHAR(50),
			Inciso						INT,
			Prima						DECIMAL,
			NumPermiso					VARCHAR(150),
			TipoPermiso					VARCHAR(50),
			Maniobras					INT,
			Motor						VARCHAR(50),
			FactorCo2					DECIMAL,
			TagCaseta					VARCHAR(50),
			UltimoOdometro				DECIMAL,
			Estado						BIT,
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),
			
			-- Campos de control
			RegistroValido				BIT DEFAULT 1,
			MotivoRechazo				VARCHAR(MAX)
		)

    -- 2. Valída que se tenga una cadena de texto JSON válida con información
		IF @ListaVehiculosJson IS NULL
			BEGIN
				-- No se envío información en el parámetro de entrada
				SET @Resultado = -1;
				INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
					VALUES('No se ha enviado información de los Vehículos para almacenar', 0);
				GOTO SALIDA;
			END
		ELSE IF ISJSON(@ListaVehiculosJson) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
					VALUES('La información de los vehículos no está en formato JSON esperado', 0);
				GOTO SALIDA;				
			END;


	-- 3. Inserta la información necesaria proveniente del JSON
		INSERT INTO #TablaTmp (
					Placa,
					Economico,
					Vin,
					-- Textos de las llaves foráneas
					Marca,
					Modelo,
					Color,
					TipoCombustible,
					Esquema,
					ProveedorSeguro,
					Configuracion,
					Proveedor,
					Tipo,
					Colaborador,
					-- Textos que deberán ser convertidos a un formato JSON
					GrupoVehiculo,
					Un,
					HabilidadVehiculos,
					RangoOperacion,
					-- Campos complementarios
					Anio,
					TanqueCombustible,
					RendimientoMixto,
					RendimientoUrbano,
					RendimientoSuburbano,
					CapacidadVolumen,
					CapacidadVolumenEfectivo,
					Factura,
					FacturaCarrocero,
					PolizaSeguro,
					Inciso,
					Prima,
					NumPermiso,
					TipoPermiso,
					Maniobras,
					Motor,
					FactorCo2,
					TagCaseta,
					UltimoOdometro,
					-- Campos de control
					Usuario,
					Trail)
			SELECT * FROM OPENJSON (@ListaVehiculosJson)
				WITH
				(
					Placa						VARCHAR(50),
					Economico					VARCHAR(150),
					Vin							VARCHAR(50),
					-- Textos de las llaves foráneas
					Marca						VARCHAR(200),
					Modelo						VARCHAR(200),
					Color						VARCHAR(150),
					TipoCombustible				VARCHAR(150),
					Esquema						VARCHAR(150),
					ProveedorSeguro				VARCHAR(500),
					Configuracion				VARCHAR(150),
					Proveedor					VARCHAR(500),
					Tipo						VARCHAR(150),
					Colaborador					VARCHAR(500),
					-- Textos que deberán ser convertidos a un formato JSON
					GrupoVehiculo				VARCHAR(3000),
					Un							VARCHAR(5000),
					HabilidadVehiculos			VARCHAR(5000),
					RangoOperacion				VARCHAR(3000),
					-- Campos complementarios
					Anio						INT,
					TanqueCombustible			INT,
					RendimientoMixto			DECIMAL,
					RendimientoUrbano			DECIMAL,
					RendimientoSuburbano		DECIMAL,
					CapacidadVolumen			INT,
					CapacidadVolumenEfectivo	INT,
					Factura						VARCHAR(150),
					FacturaCarrocero			VARCHAR(150),
					PolizaSeguro				VARCHAR(50),
					Inciso						INT,
					Prima						DECIMAL,
					NumPermiso					VARCHAR(150),
					TipoPermiso					VARCHAR(50),
					Maniobras					INT,
					Motor						VARCHAR(50),
					FactorCo2					DECIMAL,
					TagCaseta					VARCHAR(50),
					UltimoOdometro				DECIMAL,
					-- Campos de control
					Usuario						VARCHAR(150),
					Trail						VARCHAR(MAX)
				)


	-- 4. Marca los registros en los que puede duplicarse la información del Vehículo (Placa, Economico o VIN)
		UPDATE #TablaTmp
			SET
				RegistroValido = 0,
				MotivoRechazo = 'Ya existe registrado un vehículo con la misma Placa, Económico y/o VIN en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
		FROM #TablaTmp
		INNER JOIN Vehiculos.Vehiculos V_V
			ON UPPER(#TablaTmp.Placa) = UPPER(V_V.Placa)
			OR UPPER(#TablaTmp.Economico) = UPPER(V_V.Economico)
			OR UPPER(#TablaTmp.Vin) = UPPER(V_V.VIN)
			
	-- 4. Marca los registros de la tabla temporal que se encuentran duplicados para solo insertar el último citado en el archivo CSV
		/*
		UPDATE #TablaTmp
			SET
				Id = V.Id,
				RegistroValido = CASE
									WHEN Rep.ConsecutivoPorRegistroByPlaca > 1 OR Rep.ConsecutivoPorRegistroByEconomico > 1 OR Rep.ConsecutivoPorRegistroByVIN > 1 THEN 0
									ELSE 1 END,
				MotivoRechazo = CASE
									WHEN Rep.ConsecutivoPorRegistroByPlaca > 1 OR Rep.ConsecutivoPorRegistroByEconomico > 1 OR Rep.ConsecutivoPorRegistroByVIN > 1 THEN 'Ya existe registrado un vehículo con la misma Placa, Económico y/o VIN en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
									ELSE NULL END
		FROM #TablaTmp
			INNER JOIN (
				SELECT
					ROW_NUMBER() OVER (PARTITION BY Placa ORDER BY Linea DESC) AS ConsecutivoPorRegistroByPlaca,
					ROW_NUMBER() OVER (PARTITION BY Economico ORDER BY Linea DESC) AS ConsecutivoPorRegistroByEconomico,
					ROW_NUMBER() OVER (PARTITION BY VIN ORDER BY Linea DESC) AS ConsecutivoPorRegistroByVIN,
					Linea
				FROM #TablaTmp
				WHERE RegistroValido = 1
			) AS Rep ON #TablaTmp.Linea = Rep.Linea
			INNER JOIN Vehiculos.Vehiculos V
				ON UPPER(V.Placa) = UPPER(#TablaTmp.Placa)
				OR UPPER(V.Economico) = UPPER(#TablaTmp.Economico)
				OR UPPER(V.VIN) = UPPER(#TablaTmp.VIN)
		WHERE
			Rep.Linea = #TablaTmp.Linea
			*/
		/*
			Rep.ConsecutivoPorRegistroByPlaca > 1
			OR Rep.ConsecutivoPorRegistroByEconomico > 1
			OR Rep.ConsecutivoPorRegistroByVIN > 1;
		*/
		/*
	SELECT *
		FROM #TablaTmp
		ORDER BY Linea ASC
		*/

	-- 5.1. Reemplaza los textos por los identificadores correspondientes en las llaves foráneas y solo de aquellos registros
	-- que son únicos ya que los vehículos que fueron excluidos (RegistroValido = 0) no serán guardados
		UPDATE #TablaTmp
			SET
				-- Llaves foráneas
				MarcaId = V_Marcas.Id,
				ModeloId = V_Modelos.Id,
				ColorId =  V_Colores.Id,
				TipoCombustibleId = Comb_Tipo.Id,
				EsquemaId = V_Esquemas.Id,
				ProveedorSeguroId = Ctes_ProveedorSeguro.Id,
				ConfiguracionId = V_Configuraciones.Id,
				ProveedorId = Ctes_Proveedor.Id,
				TipoId = V_Tipos.Id,
				ColaboradorId = Op_Predeterminado.Id,
				-- Textos que deberán ser convertidos a un formato JSON
				-- === Grupo de Vehículos ===
					-- Convierte la lista de elementos en texto en un JSON
					GrupoVehiculo_JSON = (
						SELECT Grupos.Id
						FROM Vehiculos.Grupos Grupos
						INNER JOIN (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.GrupoVehiculo, '|')
						) GruposByVehiculo
						ON UPPER(LTRIM(RTRIM(GruposByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Grupos.Nombre)))
						AND Grupos.Eliminado = 1
						FOR JSON PATH
					),
					-- Calcula el número de elementos como texto separados por el caracter pipe que se recibieron en el JSON de entrada
					GrupoVehiculoRecibidos = (
						SELECT COUNT(*)
						FROM (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.GrupoVehiculo, '|')
						) AS GrupoCuentaRecibidos
					),
					-- Calcula el número de elementos que realmente se encontraron registrados en el catálogo correspondiente una vez que fueron separados por el caracter pipe en el JSON de entrada
					GrupoVehiculoValidados = (
						SELECT COUNT(*)
						FROM (
							SELECT Grupos.Id
							FROM Vehiculos.Grupos Grupos
							INNER JOIN (
								SELECT DISTINCT(VALUE)
								FROM STRING_SPLIT(#TablaTmp.GrupoVehiculo, '|')
							) GruposByVehiculo
							ON UPPER(LTRIM(RTRIM(GruposByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Grupos.Nombre)))
							AND Grupos.Eliminado = 1
						) AS GrupoCuentaValidados
					),
				-- ==== Unidades de Negocio ====
					-- Convierte la lista de elementos en texto en un JSON
					UN_JSON = (
						SELECT Uns.Id
						FROM Productos.UN Uns
						INNER JOIN (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.UN, '|')
						) UnsByVehiculo
						ON UPPER(LTRIM(RTRIM(UnsByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Uns.Nombre)))
						AND Uns.Eliminado = 1
						FOR JSON PATH
					),
					-- Calcula el número de elementos como texto separados por el caracter pipe que se recibieron en el JSON de entrada
					UNRecibidos = (
						SELECT COUNT(*)
						FROM (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.UN, '|')
						) AS GrupoCuentaRecibidos
					),
					-- Calcula el número de elementos que realmente se encontraron registrados en el catálogo correspondiente una vez que fueron separados por el caracter pipe en el JSON de entrada
					UNValidados = (
						SELECT COUNT(*)
						FROM (
							SELECT Uns.Id
							FROM Productos.UN Uns
							INNER JOIN (
								SELECT DISTINCT(VALUE)
								FROM STRING_SPLIT(#TablaTmp.UN, '|')
							) UnsByVehiculo
							ON UPPER(LTRIM(RTRIM(UnsByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Uns.Nombre)))
							AND Uns.Eliminado = 1
						) AS GrupoCuentaValidados
					),
				-- ==== Habilidades ====
					-- Convierte la lista de elementos en texto en un JSON
					HabilidadVehiculos_JSON = (
						SELECT Habilidades.Id
						FROM Vehiculos.HabilidadesVehiculos Habilidades
						INNER JOIN (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.HabilidadVehiculos, '|')
						) HabilidadesByVehiculo
						ON UPPER(LTRIM(RTRIM(HabilidadesByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Habilidades.Nombre)))
						AND Habilidades.Eliminado = 1
						FOR JSON PATH
					),
					-- Calcula el número de elementos como texto separados por el caracter pipe que se recibieron en el JSON de entrada
					HabilidadVehiculosRecibidos = (
						SELECT COUNT(*)
						FROM (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.HabilidadVehiculos, '|')
						) AS GrupoCuentaRecibidos
					),
					-- Calcula el número de elementos que realmente se encontraron registrados en el catálogo correspondiente una vez que fueron separados por el caracter pipe en el JSON de entrada
					HabilidadVehiculosValidados = (
						SELECT COUNT(*)
						FROM (
							SELECT Habilidades.Id
							FROM Vehiculos.HabilidadesVehiculos Habilidades
							INNER JOIN (
								SELECT DISTINCT(VALUE)
								FROM STRING_SPLIT(#TablaTmp.HabilidadVehiculos, '|')
							) HabilidadesByVehiculo
							ON UPPER(LTRIM(RTRIM(HabilidadesByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(Habilidades.Nombre)))
							AND Habilidades.Eliminado = 1
						) AS GrupoCuentaValidados
					),
				-- ==== Rangos de Operación ====
					-- Convierte la lista de elementos en texto en un JSON
					RangoOperacion_JSON = (
						SELECT RangosOperacion.Id
						FROM Clientes.RangosOperaciones RangosOperacion
						INNER JOIN (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.RangoOperacion, '|')
						) RangosOperacionByVehiculo
						ON UPPER(LTRIM(RTRIM(RangosOperacionByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(RangosOperacion.Nombre)))
						AND RangosOperacion.Eliminado = 1
						FOR JSON PATH
					),
					-- Calcula el número de elementos como texto separados por el caracter pipe que se recibieron en el JSON de entrada
					RangoOperacionRecibidos = (
						SELECT COUNT(*)
						FROM (
							SELECT DISTINCT(VALUE)
							FROM STRING_SPLIT(#TablaTmp.RangoOperacion, '|')
						) AS GrupoCuentaRecibidos
					),
					-- Calcula el número de elementos que realmente se encontraron registrados en el catálogo correspondiente una vez que fueron separados por el caracter pipe en el JSON de entrada
					RangoOperacionValidados = (
						SELECT COUNT(*)
						FROM (
							SELECT RangosOperacion.Id
							FROM Clientes.RangosOperaciones RangosOperacion
							INNER JOIN (
								SELECT DISTINCT(VALUE)
								FROM STRING_SPLIT(#TablaTmp.RangoOperacion, '|')
							) RangosOperacionByVehiculo
							ON UPPER(LTRIM(RTRIM(RangosOperacionByVehiculo.VALUE))) = UPPER(LTRIM(RTRIM(RangosOperacion.Nombre)))
							AND RangosOperacion.Eliminado = 1
						) AS GrupoCuentaValidados
					),
				-- Actualiza el motivo de rechazo
				MotivoRechazo =
					CASE
						-- Campos que son llaves foraneas pero no se recibió información
						WHEN #TablaTmp.Marca IS NULL THEN 'La marca no ha sido definida en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Modelo IS NULL THEN 'El modelo no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Color IS NULL THEN 'El color no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.TipoCombustible IS NULL THEN 'El tipo de combustible no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Esquema IS NULL THEN 'El esquema no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.ProveedorSeguro IS NULL THEN 'El proveedor del seguro no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Configuracion IS NULL THEN 'La configuración no ha sido definida en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Proveedor IS NULL THEN 'El proveedor no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Tipo IS NULL THEN 'El tipo de vehículo no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN #TablaTmp.Colaborador IS NULL THEN 'El operador predeterminado no ha sido definido en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						-- Campos que no se encontraron en su respectivo catálogo
						WHEN V_Marcas.Id IS NULL THEN 'La marca "' + #TablaTmp.Marca + '" no ha sido encontrada en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN V_Modelos.Id IS NULL THEN
								'El modelo "' + #TablaTmp.Modelo + '" ' + 
									(
										CASE WHEN V_Marcas.Id IS NOT NULL THEN ' de la marca "' + #TablaTmp.Marca + '" ' END
									) +
								'no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN V_Colores.Id IS NULL THEN 'El color "' + #TablaTmp.Color + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN Comb_Tipo.Id IS NULL THEN 'El tipo de combustible "' + #TablaTmp.TipoCombustible + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN V_Esquemas.Id IS NULL THEN 'El esquema "' + #TablaTmp.Esquema + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN Ctes_ProveedorSeguro.Id IS NULL THEN 'El proveedor del seguro "' + #TablaTmp.ProveedorSeguro + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN V_Configuraciones.Id IS NULL THEN 'La configuración "' + #TablaTmp.Configuracion + '" no ha sido encontrada en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN Ctes_Proveedor.Id IS NULL THEN 'El proveedor "' + #TablaTmp.Proveedor + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN V_Tipos.Id IS NULL THEN 'El tipo "' + #TablaTmp.Tipo + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN Op_Predeterminado.Id IS NULL THEN 'El operador predeterminado "' + #TablaTmp.Colaborador + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						ELSE #TablaTmp.MotivoRechazo
					END,
				-- Actualiza la bandera de RegistroValido
				RegistroValido = 
					CASE
						WHEN
							V_Marcas.Id IS NULL OR V_Modelos.Id IS NULL OR V_Colores.Id IS NULL OR
							Comb_Tipo.Id IS NULL OR V_Esquemas.Id IS NULL OR Ctes_ProveedorSeguro.Id IS NULL OR
							V_Configuraciones.Id IS NULL OR Ctes_Proveedor.Id IS NULL OR V_Tipos.Id IS NULL OR
							Op_Predeterminado.Id IS NULL THEN 0
						ELSE RegistroValido
					END
		FROM #TablaTmp	
		-- Marcas
			LEFT JOIN Vehiculos.Marcas V_Marcas
				ON UPPER(LTRIM(RTRIM(V_Marcas.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Marca)))
				AND V_Marcas.Eliminado = 1
		-- Modelos
			LEFT JOIN Vehiculos.Modelos V_Modelos
				ON UPPER(LTRIM(RTRIM(V_Modelos.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Modelo)))
				AND V_Marcas.Id = V_Modelos.MarcaId
				AND V_Modelos.Eliminado = 1
		-- Color
			LEFT JOIN Vehiculos.Colores V_Colores
				ON UPPER(LTRIM(RTRIM(V_Colores.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Color)))
				AND V_Colores.Eliminado = 1
		-- Tipo de Combustible
			LEFT JOIN Combustibles.TiposCombustibles Comb_Tipo
				ON UPPER(LTRIM(RTRIM(Comb_Tipo.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.TipoCombustible)))
				AND Comb_Tipo.Eliminado = 1
		-- Esquema
			LEFT JOIN Vehiculos.Esquemas V_Esquemas
				ON UPPER(LTRIM(RTRIM(V_Esquemas.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Esquema)))
				AND V_Esquemas.Eliminado = 1
		-- Proveedor Seguro
			LEFT JOIN Clientes.Proveedores Ctes_ProveedorSeguro
				ON UPPER(LTRIM(RTRIM(Ctes_ProveedorSeguro.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.ProveedorSeguro)))
				AND Ctes_ProveedorSeguro.Eliminado = 1
		-- Configuración
			LEFT JOIN Vehiculos.Configuraciones V_Configuraciones
				ON UPPER(LTRIM(RTRIM(V_Configuraciones.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Configuracion)))
				AND V_Configuraciones.Eliminado = 1
		-- Proveedor Seguro
			LEFT JOIN Clientes.Proveedores Ctes_Proveedor
				ON UPPER(LTRIM(RTRIM(Ctes_Proveedor.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Proveedor)))
				AND Ctes_Proveedor.Eliminado = 1
		-- Tipo de Vehiculo
			LEFT JOIN Vehiculos.Tipos V_Tipos
				ON UPPER(LTRIM(RTRIM(V_Tipos.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Tipo)))
				AND V_Tipos.Eliminado = 1
		-- Colaboradores como Operador Predeterminado
			LEFT JOIN Operadores.Colaboradores Op_Predeterminado
				ON UPPER(LTRIM(RTRIM(Op_Predeterminado.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Colaborador)))
				AND Op_Predeterminado.Eliminado = 1
		WHERE RegistroValido = 1

	-- 5.2. Analiza solo las columnas que contienen textos en formato JSON para corroborar que tengan información
		UPDATE #TablaTmp
			SET
				-- Actualiza el motivo de rechazo
				MotivoRechazo =
					CASE
						-- Sin información cargada
						--WHEN GrupoVehiculo_JSON IS NULL THEN 'No se ha definido el grupo de vehículos en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						--WHEN UN_JSON IS NULL THEN 'No se ha definido la lista de UN en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						--WHEN HabilidadVehiculos_JSON IS NULL THEN 'No se ha definido la lista de habilidades en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						--WHEN RangoOperacion_JSON IS NULL THEN 'No se ha definido la lista de rangos de operación en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						-- Con información con discrepancias entre los recibido y lo que está en el catálogo correspondiente
						WHEN GrupoVehiculoRecibidos <> GrupoVehiculoValidados THEN 'Se ha(n) recibido ' + CAST(GrupoVehiculoRecibidos AS varchar(MAX)) + ' elemento(s) en la lista de grupos de vehículos y se encontró(aron) ' + CAST(GrupoVehiculoValidados AS varchar(MAX)) + ' elemento(s) registrado(s) en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN UNRecibidos <> UNValidados THEN 'Se ha(n) recibido ' + CAST(UNRecibidos AS varchar(MAX)) + ' elemento(s) en la lista de UN y se encontró(aron) ' + CAST(UNValidados AS varchar(MAX)) + ' elemento(s) registrado(s) en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN HabilidadVehiculosRecibidos <> HabilidadVehiculosValidados THEN 'Se ha(n) recibido ' + CAST(HabilidadVehiculosRecibidos AS varchar(MAX)) + ' elemento(s) en la lista de habilidades y se encontró(aron) ' + CAST(HabilidadVehiculosValidados AS varchar(MAX)) + ' elemento(s) registrado(s) en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN RangoOperacionRecibidos <> RangoOperacionValidados THEN 'Se ha(n) recibido ' + CAST(RangoOperacionRecibidos AS varchar(MAX)) + ' elemento(s) en la lista de rangos de operación y se encontró(aron) ' + CAST(RangoOperacionValidados AS varchar(MAX)) + ' elemento(s) registrado(s) en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						ELSE #TablaTmp.MotivoRechazo
					END,
				-- Actualiza la bandera de RegistroValido
				RegistroValido = 
					CASE
						-- Sin información cargada
						-- Los campos son opcionales por lo que no es necesario información cargada
						--WHEN
							--GrupoVehiculo_JSON IS NULL OR UN_JSON IS NULL OR HabilidadVehiculos_JSON IS NULL OR
							--RangoOperacion_JSON IS NULL THEN 0
						-- Con información con discrepancias entre los recibido y lo que está en el catálogo correspondiente
						WHEN GrupoVehiculoRecibidos <> GrupoVehiculoValidados OR
							UNRecibidos <> UNValidados OR
							HabilidadVehiculosRecibidos <> HabilidadVehiculosValidados OR
							RangoOperacionRecibidos <> RangoOperacionValidados THEN 0
						ELSE RegistroValido
					END
		WHERE RegistroValido = 1


/*
	-- ACTUALIZACIÓN E INSERCIÓN DE REGISTROS
	-- 6. Actualiza los registros que ya estaban almacenados previamenre en la Base de Datos
		UPDATE Vehiculos.Vehiculos
		SET
			MarcaId = #T.MarcaId,
			ModeloId = #T.ModeloId,
			Anio = #T.Anio,
			ColorId = #T.ColorId,
			TipoCombustibleId = #T.TipoCombustibleId,
			TanqueCombustible = #T.TanqueCombustible,
			RendimientoMixto = #T.RendimientoMixto,
			RendimientoUrbano = #T.RendimientoUrbano,
			RendimientoSuburbano = #T.RendimientoSuburbano,
			CapacidadVolumen = #T.CapacidadVolumen,
			CapacidadVolumenEfectivo = #T.CapacidadVolumenEfectivo,
			ProveedorId = #T.ProveedorId,
			EsquemaId = #T.EsquemaId,
			Factura = #T.Factura,
			FacturaCarrocero = #T.FacturaCarrocero,
			GrupoVehiculo = LOWER(#T.GrupoVehiculo_JSON),
			ProveedorSeguroId = #T.ProveedorSeguroId,
			PolizaSeguro = #T.PolizaSeguro,
			Inciso = #T.Inciso,
			Prima = #T.Prima,
			NumPermiso = #T.NumPermiso,
			TipoPermiso = #T.TipoPermiso,
			ConfiguracionId = #T.ConfiguracionId,
			HabilidadVehiculos = #T.HabilidadVehiculos,
			TipoId = #T.TipoId,
			ColaboradorId = #T.ColaboradorId,
			RangoOperacion = #T.RangoOperacion,
			Maniobras = #T.Maniobras,
			UN = #T.UN,
			Motor = #T.Motor,
			FactorCO2 = #T.FactorCO2,
			TagCaseta = #T.TagCaseta,
			UltimoOdometro = #T.UltimoOdometro,
			Estado = #T.Estado,
			Usuario = #T.Usuario,
			Trail = #T.Trail
		FROM Vehiculos.Vehiculos AS Vehiculos
		INNER JOIN #TablaTmp #T
			ON #T.Id = Vehiculos.Id
		WHERE
			-- Registros válidos y solo una vez
			#T.RegistroValido = 1
			-- Identificadores de los registros que ya han sido insertados previamente
			AND #T.Id > 0
*/

	-- 6.1 Inserta solo los registros que son correctos
		DECLARE @IdentificadoresGenerados TABLE (
			VehiculoId		INT,			-- Identificador del Vehiculo con el que se guardó en la tabla final
			Placa			VARCHAR(50),
			Economico		VARCHAR(150),
			Vin				VARCHAR(50)
		);

		INSERT INTO Vehiculos.Vehiculos (
			Placa,
			Economico,
			VIN,
			MarcaId,
			ModeloId,
			Anio,
			ColorId,
			TipoCombustibleId,
			TanqueCombustible,
			RendimientoMixto,
			RendimientoUrbano,
			RendimientoSuburbano,
			CapacidadVolumen,
			CapacidadVolumenEfectivo,
			ProveedorId,
			EsquemaId,
			Factura,
			FacturaCarrocero,
			GrupoVehiculo,
			ProveedorSeguroId,
			PolizaSeguro,
			Inciso,
			Prima,
			NumPermiso,
			TipoPermiso,
			ConfiguracionId,
			HabilidadVehiculos,
			TipoId,
			ColaboradorId,
			RangoOperacion,
			Maniobras,
			UN,
			Motor,
			FactorCO2,
			TagCaseta,
			UltimoOdometro,
			Estado,
			Eliminado,
			Usuario,
			FechaCreacion,
			Trail
		)
		OUTPUT INSERTED.Id, INSERTED.Placa, INSERTED.Economico, INSERTED.VIN INTO @IdentificadoresGenerados(VehiculoId, Placa, Economico, Vin)
		SELECT
			Placa,
			Economico,
			VIN,
			MarcaId,
			ModeloId,
			Anio,
			ColorId,
			TipoCombustibleId,
			TanqueCombustible,
			RendimientoMixto,
			RendimientoUrbano,
			RendimientoSuburbano,
			CapacidadVolumen,
			CapacidadVolumenEfectivo,
			ProveedorId,
			EsquemaId,
			Factura,
			FacturaCarrocero,
			LOWER(GrupoVehiculo_JSON),
			ProveedorSeguroId,
			PolizaSeguro,
			Inciso,
			Prima,
			NumPermiso,
			TipoPermiso,
			ConfiguracionId,
			LOWER(HabilidadVehiculos_JSON),
			TipoId,
			ColaboradorId,
			LOWER(RangoOperacion_JSON),
			Maniobras,
			LOWER(UN_JSON),
			Motor,
			FactorCO2,
			TagCaseta,
			UltimoOdometro,
			1,
			1,
			Usuario,
			CURRENT_TIMESTAMP,
			Trail
		FROM #TablaTmp #T
		WHERE #T.RegistroValido = 1
		-- Solo inserta registros nuevos con Identificador = 0
		AND #T.Id = 0;

	-- Actualiza la tabla temporal con los identificadores que fueron generados al insertar los registros de los vehículos
		UPDATE #TablaTmp
			SET #TablaTmp.Id = Ids.VehiculoId
		FROM #TablaTmp #T
		INNER JOIN @IdentificadoresGenerados Ids
			ON Ids.Placa = #T.Placa
			AND Ids.Economico = #T.Economico
			AND Ids.Vin = #T.Vin
		WHERE #T.RegistroValido = 1;

	-- 6.2 Inserta los grupos de vehiculos en la tabla relacional
		-- Definición de la variable como tabla
		INSERT INTO GruposDetalles(VehiculoId, GrupoId, FechaCreacion, Usuario, Eliminado, Trail)
			SELECT
				#TablaTmp.Id AS VehiculoId,
				JsonOriginal.Id AS GrupoId,
				CURRENT_TIMESTAMP,
				#TablaTmp.Usuario,
				1,
				#TablaTmp.Trail
				--#TablaTmp.GrupoVehiculo_JSON
			FROM #TablaTmp
			-- Desdobla la cadena JSON y realiza el cruce entre el Id del Vehiculo y cada Identificador de Grupo
			CROSS APPLY OPENJSON(#TablaTmp.GrupoVehiculo_JSON)
			WITH (
				Id INT
			) AS JsonOriginal
			WHERE #TablaTmp.RegistroValido = 1
			AND #TablaTmp.Id > 0;
	--SELECT * FROM #TablaTmp;		



	-- 7. Recupera las estadísticas y la lista de mensajes para informar lo sucedido en la ejeción del SP
	SALIDA:
		-- Número de registros para tratar de insertar
		SELECT @NumRegistrosTotales = COUNT(*) FROM #TablaTmp;
		-- Número de registros realmente insertados
		SELECT @NumRegistrosInsertados = COUNT(*) FROM #TablaTmp WHERE Id > 0;
		-- Lista de mensajes de error encontrados
		SET @DetalleMensajesError = (SELECT #TablaTmp.Linea, #TablaTmp.MotivoRechazo FROM #TablaTmp WHERE RegistroValido = 0 FOR JSON PATH);
		-- Mensaje de salida en formato JSON
		SELECT @Mensaje =	'{"registrosTotales":' + CAST(@NumRegistrosTotales AS VARCHAR(MAX)) + ',' +
								'"registrosInsertados":' + CAST( @NumRegistrosInsertados AS VARCHAR(MAX)) + ',' + 
								'"mensajesError":' +
									(CASE
										WHEN @DetalleMensajesError IS NOT NULL THEN @DetalleMensajesError
										ELSE '""' END
									) +
							'}';

	
	-- 8. Elimina la tabla temporal usada para el tratamiento de la información
		DROP TABLE #TablaTmp;


	-- 9. Finalmente devuelve el resultado de la ejecución del SP junto con su respectivo mensaje
		SELECT
			CASE WHEN @Resultado >= 0 THEN @NumRegistrosTotales ELSE @Resultado END AS TotalRows,
			@Mensaje AS JsonSalida;
END
GO
