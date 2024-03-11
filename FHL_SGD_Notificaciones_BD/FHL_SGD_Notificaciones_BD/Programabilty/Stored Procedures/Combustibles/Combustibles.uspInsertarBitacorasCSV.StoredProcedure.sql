USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspInsertarBitacorasCSV]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:      NewlandApps
-- Create date: Julio de 2023
-- Description: Inserta una lista de bitacoras combustibles pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Combustibles].[uspInsertarBitacorasCSV]
    -- Add the parameters for the stored procedure here
    @ListaBitacorasJson         VARCHAR(MAX) = NULL
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    -- Variables de salida al ejecutar el SP
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = NULL;
    DECLARE @NumRegistrosTotales        INT = 0;    -- Indica cuantos registros totales fueron pasados en la cadena JSON de entrada
    DECLARE @NumRegistrosInsertados     INT = 0;    -- Indica cuantos registros fueron insertados correctamente en la tabla correspondiente
    DECLARE @DetalleMensajesError		VARCHAR(MAX) = NULL;	-- Recupera la lista de errores en cada registro


    -- 1. Crea una tabla temporal para guardar la información provieniente de la cadena JSON pasada como parámetro
        CREATE TABLE #TablaTmp(
            Linea                       INT NOT NULL IDENTITY(2,1), -- En el archivo CSV los datos inician en la línea 2 ya que la primera línea pertenece a los encabezados
            Id							INT DEFAULT 0, -- Identificador que se actualizará al momento de realizar la inserción de la información de cada registro
            --

            FechaRegistro               DATETIME,
            FechaCarga                  DATETIME,
            Combustible                 VARCHAR(50),
            Factura                     VARCHAR(50),
            OdometroActual              NUMERIC(18,2),
            OdometroAnterior            NUMERIC(18,2),
            Litros                      NUMERIC(18,2),
			MonedaIdCosto				INT,
			DivisaCosto                 VARCHAR(50),
            Costo                       NUMERIC(18,2),
            RendimientoCalculado        NUMERIC(18,2),
			MonedaIdCostoTotal			INT,
			DivisaCostoTotal            VARCHAR(50),
            CostoTotal                  NUMERIC(18,2),
			MonedaIdIVA					INT,
			DivisaIVA                   VARCHAR(50),
            IVA                         NUMERIC(18,2),
			MonedaIdIEPS				INT,
			DivisaIEPS                  VARCHAR(50),
            IEPS                        NUMERIC(18,2),
            Comentario                  VARCHAR(250),
            Duracion                    TIME(7),
            Referencia                  VARCHAR(250),

            -- Identificadores de llaves foraneas y textos originales en el JSON
            -- Vehiculos(Económico)
            VehiculosId                 BIGINT,
            Vehiculos                   VARCHAR(200),
            -- Tipo de Combustible
            TiposCombustiblesId         BIGINT,
            TiposCombustibles           VARCHAR(200),
            -- Estaciones
            EstacionesId                BIGINT,
            Estaciones                  VARCHAR(150),
            -- Colaboradores
            ColaboradoresId             BIGINT,
            Colaboradores               VARCHAR(150),

            --
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),

            --Campos para mensaje
            RegistroValido              BIT DEFAULT 1,
            MotivoRechazo               VARCHAR(MAX)
        )

    -- 2. Valida que se tenga una cadena de texto JSON con información
        IF @ListaBitacorasJson IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'No se ha enviado información de las Bitacoras para almacenar';
                GOTO SALIDA;
            END;
        ELSE IF ISJSON(@ListaBitacorasJson) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
                INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
                    VALUES('La información de las bitacoras no está en formato JSON esperado', 0);
                GOTO SALIDA;                
            END;

    -- 3. Inserta la información necesaria proveniente del JSON
        INSERT INTO #TablaTmp (
                    FechaRegistro,
                    FechaCarga,
                    Combustible,
                    Factura,
                    OdometroActual,
                    OdometroAnterior,
                    Litros,
					DivisaCosto,
                    Costo,
                    RendimientoCalculado,
					DivisaCostoTotal,
                    CostoTotal,
					DivisaIVA,
                    IVA,
					DivisaIEPS,
                    IEPS,
                    Comentario,
                    Duracion,
                    Referencia,
                    -- Textos de las llaves foráneas
                    Vehiculos,
                    TiposCombustibles,
                    Estaciones,
                    Colaboradores,
                    --
                    Usuario,
                    Trail)
            SELECT * FROM OPENJSON (@ListaBitacorasJson)
                WITH
                (
                    FechaRegistro               DATETIME,
                    FechaCarga                  DATETIME,
                    Combustible                 VARCHAR(50),
                    Factura                     VARCHAR(50),
                    OdometroActual              NUMERIC(18,2),
                    OdometroAnterior            NUMERIC(18,2),
                    Litros                      NUMERIC(18,2),
					DivisaCosto                 VARCHAR(50),
                    Costo                       NUMERIC(18,2),
                    RendimientoCalculado        NUMERIC(18,2),
					DivisaCostoTotal            VARCHAR(50),
                    CostoTotal                  NUMERIC(18,2),
					DivisaIVA                   VARCHAR(50),
                    Iva                         NUMERIC(18,2),
					DivisaIEPS                  VARCHAR(50),
                    Ieps                        NUMERIC(18,2),
                    Comentario                  VARCHAR(250),
                    Duracion                    TIME(7),
                    Referencia                  VARCHAR(250),

                    -- Textos de las llaves foráneas
                    Vehiculos                   VARCHAR(200),
                    TiposCombustibles           VARCHAR(200),
                    Estaciones                  VARCHAR(150),
                    Colaboradores               VARCHAR(150),

                    --
                    Usuario                     VARCHAR(150),
                    Trail						VARCHAR(MAX)
                )


	-- 4.0 Asignaremos un valor de divisa entero dependiendo el texto insertado en el CSV
		-- Actualiza MonedaIdCosto basado en DivisaCosto
			UPDATE #TablaTmp
				SET 
					MonedaIdCosto = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaCosto))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaCosto))) = 'USD' THEN 2
							ELSE MonedaIdCosto  -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(DivisaCosto))) IN ('MXN', 'USD');

		-- Actualiza MonedaIdCostoTotal basado en DivisaCostoTotal
			UPDATE #TablaTmp
				SET 
					MonedaIdCostoTotal = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaCostoTotal))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaCostoTotal))) = 'USD' THEN 2
							ELSE MonedaIdCosto  -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(DivisaCostoTotal))) IN ('MXN', 'USD');

		-- Actualiza MonedaIdIVA basado en DivisaIVA
			UPDATE #TablaTmp
				SET 
					MonedaIdIVA = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaIVA))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaIVA))) = 'USD' THEN 2
							ELSE MonedaIdIVA  -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(DivisaIVA))) IN ('MXN', 'USD');

		-- Actualiza MonedaIdIEPS basado en DivisaIEPS
			UPDATE #TablaTmp
				SET 
					MonedaIdIEPS = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaIEPS))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaIEPS))) = 'USD' THEN 2
							ELSE MonedaIdIEPS  -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(DivisaIEPS))) IN ('MXN', 'USD');



	--4.1 Crearemos los registros invalidos para los casos en los que se haya ingresado correctamente el texto para la divisa
		UPDATE #TablaTmp
			SET	
				--Actualizamos el motivo de rechazo
				MotivoRechazo =
					CASE
						WHEN MonedaIdCosto IS NULL THEN 'La divisa de costo "' + #TablaTmp.DivisaCosto + '" no es valida (MXN/USD) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN MonedaIdCostoTotal IS NULL THEN 'La divisa de costo total"' + #TablaTmp.DivisaCostoTotal + '" no es valida (MXN/USD) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN MonedaIdIVA IS NULL THEN 'La divisa de IVA "' + #TablaTmp.DivisaIVA + '" no es valida (MXN/USD) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN MonedaIdIEPS IS NULL THEN 'La divisa de IEPS "' + #TablaTmp.DivisaIEPS + '" no es valida (MXN/USD) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						ELSE #TablaTmp.MotivoRechazo END,
				--
				RegistroValido = 
                    CASE
                        WHEN
                            MonedaIdCosto IS NULL OR MonedaIdCostoTotal IS NULL OR MonedaIdIVA IS NULL OR
                            MonedaIdIEPS IS NULL THEN 0
                        ELSE RegistroValido END



    -- 5. Reemplaza los textos por los identificadores correspondientes en las llaves foráneas y solo de aquellos registros
    -- que son únicos ya que los vehículos que fueron excluidos (RegistroValido = 0) no serán guardados
        UPDATE #TablaTmp
            SET
                VehiculosId = CB_Vehiculo.Id,
                TiposCombustiblesId = CB_TiposCombustibles.Id,
                EstacionesId = CB_Estaciones.Id,
                ColaboradoresId = CB_Colaboradores.Id,
            
                -- Actualiza el motivo de rechazo
                MotivoRechazo =
                    CASE
                        WHEN CB_Vehiculo.Id IS NULL THEN 'El económico "' + #TablaTmp.Vehiculos + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_Estaciones.Id IS NULL THEN 'La estación "' + #TablaTmp.Estaciones + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_TiposCombustibles.Id IS NULL THEN 'El tipo de combustible "' + #TablaTmp.TiposCombustibles + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_Colaboradores.Id IS NULL THEN 'El colaborador "' + #TablaTmp.Colaboradores + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        ELSE #TablaTmp.MotivoRechazo END,
                -- Actualiza la bandera de RegistroValido
                RegistroValido = 
                    CASE
                        WHEN
                            CB_Vehiculo.Id IS NULL OR CB_Estaciones.Id IS NULL OR CB_TiposCombustibles.Id IS NULL OR
                            CB_Colaboradores.Id IS NULL THEN 0
                        ELSE RegistroValido END

        FROM #TablaTmp  
        -- VehiculosEconomico
            LEFT JOIN Vehiculos.Vehiculos CB_Vehiculo
                ON UPPER(LTRIM(RTRIM(CB_Vehiculo.Economico))) = UPPER(LTRIM(RTRIM(#TablaTmp.Vehiculos)))
        -- TiposCombustibles
            LEFT JOIN Combustibles.TiposCombustibles CB_TiposCombustibles
                ON UPPER(LTRIM(RTRIM(CB_TiposCombustibles.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.TiposCombustibles)))
        -- Estaciones
            LEFT JOIN Combustibles.Estaciones CB_Estaciones
                ON UPPER(LTRIM(RTRIM(CB_Estaciones.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Estaciones)))
        -- Colaborador
            LEFT JOIN Operadores.Colaboradores CB_Colaboradores
                ON UPPER(LTRIM(RTRIM(CB_Colaboradores.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Colaboradores)))


	
	-- 6. Marca los registros en los que puede duplicarse la información proveniente del CSV
			UPDATE #TablaTmp
			SET RegistroValido = 2 , MotivoRechazo ='Se ha actualizado un registro duplicado (' + #TablaTmp.Factura +') en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX)) +' del archivo CSV'
			FROM #TablaTmp
			INNER JOIN (
				SELECT
					*,
					ROW_NUMBER() OVER (PARTITION BY UPPER(LTRIM(RTRIM(Factura))) ORDER BY Linea DESC) AS rn
				FROM
					#TablaTmp
				WHERE
					RegistroValido = 1
			) AS Rep
			ON #TablaTmp.Linea = Rep.Linea
			WHERE Rep.rn != 1;

    -- 7.-  Inserta y actualiza solo los registros que son correctos

	MERGE INTO Combustibles.BitacorasCombustibles AS TARGET
		--Realizamos una consulta interna para ordenar el ultimo registro con la misma Referencia encontrado en el CSV
		USING #TablaTmp AS SOURCE
		ON UPPER(LTRIM(RTRIM(TARGET.Factura))) = UPPER(LTRIM(RTRIM(SOURCE.Factura)))
		--Se solicita que source.rn=1 por que necesitamos sea el primer registro que previamente se acomodo de forma descendente
		WHEN MATCHED AND SOURCE.RegistroValido = 1 THEN
			UPDATE SET
				TARGET.FechaRegistro = SOURCE.FechaRegistro,
				TARGET.FechaCarga = SOURCE.FechaCarga,
				TARGET.Combustible = SOURCE.Combustible,
				--TARGET.Factura = SOURCE.Factura,
				TARGET.Referencia = SOURCE.Referencia,
				TARGET.OdometroActual = SOURCE.OdometroActual,
				TARGET.OdometroAnterior = SOURCE.OdometroAnterior,
				TARGET.Litros = SOURCE.Litros,
				TARGET.MonedaIdCosto = SOURCE.MonedaIdCosto,
				TARGET.Costo = SOURCE.Costo,
				TARGET.RendimientoCalculado = SOURCE.RendimientoCalculado,
				TARGET.MonedaIdCostoTotal = SOURCE.MonedaIdCostoTotal,
				TARGET.CostoTotal = SOURCE.CostoTotal,
				TARGET.MonedaIdIVA = SOURCE.MonedaIdIVA,
				TARGET.IVA = SOURCE.IVA,
				TARGET.MonedaIdIEPS = SOURCE.MonedaIdIEPS,
				TARGET.IEPS = SOURCE.IEPS,
				TARGET.Comentario = SOURCE.Comentario,
				TARGET.Duracion = SOURCE.Duracion,
				TARGET.VehiculosId = SOURCE.VehiculosId,
				TARGET.TiposCombustiblesId = SOURCE.TiposCombustiblesId,
				TARGET.EstacionesId = SOURCE.EstacionesId,
				TARGET.ColaboradoresId = SOURCE.ColaboradoresId,
				TARGET.Usuario = SOURCE.Usuario,
				TARGET.Eliminado = 1,
				TARGET.Trail = SOURCE.Trail
		WHEN NOT MATCHED AND SOURCE.RegistroValido = 1 THEN
			INSERT (
				FechaRegistro,
				FechaCarga,
				Combustible,
				Factura,
				Referencia,
				OdometroActual,
				OdometroAnterior,
				Litros,
				MonedaIdCosto,
				Costo,
				RendimientoCalculado,
				MonedaIdCostoTotal,
				CostoTotal,
				MonedaIdIVA,
				IVA,
				MonedaIdIEPS,
				IEPS,
				Comentario,
				Duracion,
				VehiculosId,
				TiposCombustiblesId,
				EstacionesId,
				ColaboradoresId,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			)
			VALUES (
				SOURCE.FechaRegistro,
				SOURCE.FechaCarga,
				SOURCE.Combustible,
				SOURCE.Factura,
				SOURCE.Referencia,
				SOURCE.OdometroActual,
				SOURCE.OdometroAnterior,
				SOURCE.Litros,
				SOURCE.MonedaIdCosto,
				SOURCE.Costo,
				SOURCE.RendimientoCalculado,
				SOURCE.MonedaIdCostoTotal,
				SOURCE.CostoTotal,
				SOURCE.MonedaIdIVA,
				SOURCE.IVA,
				SOURCE.MonedaIdIEPS,
				SOURCE.IEPS,
				SOURCE.Comentario,
				SOURCE.Duracion,
				SOURCE.VehiculosId,
				SOURCE.TiposCombustiblesId,
				SOURCE.EstacionesId,
				SOURCE.ColaboradoresId,
				SOURCE.Usuario,
				1,
				CURRENT_TIMESTAMP,
				SOURCE.Trail
			);

    -- 8. Recupera las estadisticas y la lista de mensajes para informar lo sucedido en la ejeción del SP
    SALIDA:
        -- Número de registros para tratar de insertar
        SELECT @NumRegistrosTotales = COUNT(*) FROM #TablaTmp;
        -- Número de registros realmente insertados
        SELECT @NumRegistrosInsertados = COUNT(*) FROM #TablaTmp WHERE RegistroValido = 1;
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
        -- Elimina la tabla temporal
        DROP TABLE #TablaTmp;
        -- Devuelve el resultado de la ejecución del SP junto con su respectivo mensaje
        SELECT
			CASE WHEN @Resultado >= 0 THEN @NumRegistrosTotales ELSE @Resultado END AS TotalRows,
			@Mensaje AS JsonSalida;
END
GO
