USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarCasetasCSV]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














-- =============================================
-- Author:      NewlandApps
-- Create date: Septiembre de 2023
-- Description: Inserta una lista de registros de casetas pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarCasetasCSV]
    -- Add the parameters for the stored procedure here
    @ListaCasetas         VARCHAR(MAX) = NULL
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

			FechaHora					DATETIME,

			-- Identificadores de llaves foraneas y textos originales en el JSON
			-- Vehiculo
            VehiculoId					BIGINT,
            -- Despachos
            DespachoId					BIGINT,
            Despacho					VARCHAR(150),
            
			Estacion					VARCHAR(500),
			Referencia					VARCHAR(500),

			--Campo Monto junto con sus campos necesarios para la divisa
			MonedaIdMonto				INT,
			DivisaMonto                 VARCHAR(50),
            Monto						NUMERIC(18,2),

            --
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),

            --Campos para mensaje
            RegistroValido              INT DEFAULT 1,
            MotivoRechazo               VARCHAR(MAX)
        )

    -- 2. Valida que se tenga una cadena de texto JSON con información
        IF @ListaCasetas IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'No se ha enviado información de los Registros de ajustes para almacenar';
                GOTO SALIDA;
            END;
        ELSE IF ISJSON(@ListaCasetas) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
                INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
                    VALUES('La información de los Registros de ajustes no está en formato JSON esperado', 0);
                GOTO SALIDA;                
            END;

    -- 3. Inserta la información necesaria proveniente del JSON
        INSERT INTO #TablaTmp (
					FechaHora,
					-- Textos de las llaves foráneas
                    Despacho,
					Estacion,
					Referencia,
					DivisaMonto,
                    Monto,
                    --
                    Usuario,
                    Trail)
            SELECT * FROM OPENJSON (@ListaCasetas)
                WITH
                (
					FechaHora					DATETIME,
					-- Textos de las llaves foráneas
                    Despacho                    VARCHAR(200),
					Estacion					VARCHAR(500),
					Referencia					VARCHAR(500),
					DivisaMonto					VARCHAR(50),
                    Monto		                NUMERIC(18,2),                  
                    --
                    Usuario                     VARCHAR(150),
                    Trail						VARCHAR(MAX)
                )

    


	-- 4.0 Asignaremos un valor de divisa entero dependiendo el texto insertado en el CSV
		-- Actualiza MonedaIdCosto basado en DivisaCosto
			UPDATE #TablaTmp
				SET 
					MonedaIdMonto = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaMonto))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaMonto))) = 'USD' THEN 2
							ELSE MonedaIdMonto -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(DivisaMonto))) IN ('MXN', 'USD');

	--4.1 Crearemos los registros invalidos para los casos en los que se haya ingresado correctamente el texto para la divisa
		UPDATE #TablaTmp
			SET	
				--Actualizamos el motivo de rechazo
				MotivoRechazo =
					CASE
						WHEN MonedaIdMonto IS NULL THEN 'La divisa de monto "' + #TablaTmp.DivisaMonto + '" no es valida (MXN/USD) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						ELSE #TablaTmp.MotivoRechazo END,
				--
				RegistroValido = 
                    CASE
                        WHEN
                            MonedaIdMonto IS NULL THEN 0
                        ELSE RegistroValido END



    -- 5. Reemplaza los textos por los identificadores correspondientes en las llaves foráneas y solo de aquellos registros
    -- que son únicos ya que los vehículos que fueron excluidos (RegistroValido = 0) no serán guardados
        UPDATE #TablaTmp
            SET
                DespachoId = CB_Despacho.ManifiestoId,
                VehiculoId = CB_Vehiculo.Id,
            
                -- Actualiza el motivo de rechazo
                MotivoRechazo =
                    CASE
                        WHEN CB_Despacho.ManifiestoId IS NULL THEN 'El manifiesto "' + #TablaTmp.Despacho + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_Vehiculo.Id IS NULL THEN 'El Vehículo con económico "' + CB_Despacho.Economico + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        ELSE #TablaTmp.MotivoRechazo END,
                -- Actualiza la bandera de RegistroValido
                RegistroValido = 
                    CASE
                        WHEN
                            CB_Despacho.Id IS NULL OR CB_Vehiculo.Id IS NULL THEN 0
                        ELSE RegistroValido END

        FROM #TablaTmp  
        -- Despachos(Ticket)
            LEFT JOIN Despachos.Visores CB_Despacho
                ON UPPER(LTRIM(RTRIM(CB_Despacho.Manifiesto))) = UPPER(LTRIM(RTRIM(#TablaTmp.Despacho)))
        -- Vehículo
            LEFT JOIN Vehiculos.Vehiculos CB_Vehiculo
                ON UPPER(LTRIM(RTRIM(CB_Vehiculo.Economico))) = UPPER(LTRIM(RTRIM(CB_Despacho.Economico))) AND UPPER(LTRIM(RTRIM(CB_Vehiculo.Placa))) = UPPER(LTRIM(RTRIM(CB_Despacho.Placa)))


	-- 6. Marca los registros en los que puede duplicarse la información proveniente del CSV
			UPDATE #TablaTmp
			SET RegistroValido = 0 , MotivoRechazo ='Se ha actualizado un registro duplicado (' + #TablaTmp.Referencia +') en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' del archivo CSV'
			FROM #TablaTmp
			INNER JOIN (
				SELECT
					*,
					ROW_NUMBER() OVER (PARTITION BY UPPER(LTRIM(RTRIM(Referencia))) ORDER BY Linea DESC) AS rn
				FROM
					#TablaTmp
				WHERE
					RegistroValido = 1
			) AS Rep
			ON #TablaTmp.Linea = Rep.Linea
			WHERE Rep.rn != 1;

    -- 7.-  Inserta y actualiza solo los registros que son correctos

	MERGE INTO Despachos.Casetas AS TARGET
		--Realizamos una consulta interna para ordenar el ultimo registro con la misma Referencia encontrado en el CSV
		USING #TablaTmp AS SOURCE
		ON UPPER(LTRIM(RTRIM(TARGET.Referencia))) = UPPER(LTRIM(RTRIM(SOURCE.Referencia)))
		--Se solicita que source.rn=1 por que necesitamos sea el primer registro que previamente se acomodo de forma descendente
		WHEN MATCHED AND SOURCE.RegistroValido = 1 THEN
			UPDATE SET
				TARGET.FechaHora = SOURCE.FechaHora,
				TARGET.VehiculoId = SOURCE.VehiculoId,
				TARGET.DespachoId = SOURCE.DespachoId,
				TARGET.Estacion = SOURCE.Estacion,
				--TARGET.Referencia = SOURCE.Referencia,
				TARGET.MonedaIdMonto = SOURCE.MonedaIdMonto,
				TARGET.Monto = SOURCE.Monto,
				TARGET.Usuario = SOURCE.Usuario,
				TARGET.Eliminado = 1,
				TARGET.Trail = SOURCE.Trail
		WHEN NOT MATCHED AND SOURCE.RegistroValido = 1 THEN
			INSERT (
				FechaHora,
				VehiculoId,
				DespachoId,
				Estacion,
				Referencia,
				MonedaIdMonto,
				Monto,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			)
			VALUES (
				SOURCE.FechaHora,
				SOURCE.VehiculoId,
				SOURCE.DespachoId,
				SOURCE.Estacion,
				SOURCE.Referencia,
				SOURCE.MonedaIdMonto,
				SOURCE.Monto,
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
