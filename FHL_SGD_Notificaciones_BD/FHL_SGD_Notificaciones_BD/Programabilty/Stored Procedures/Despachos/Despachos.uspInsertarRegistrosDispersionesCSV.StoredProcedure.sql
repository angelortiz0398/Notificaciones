USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarRegistrosDispersionesCSV]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











-- =============================================
-- Author:      NewlandApps
-- Create date: Julio de 2023
-- Description: Inserta una lista de registros de dispersiones pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarRegistrosDispersionesCSV]
    -- Add the parameters for the stored procedure here
    @ListaRegistrosDispersiones         VARCHAR(MAX) = NULL
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
			MonedaIdMonto				INT,
			DivisaMonto                 VARCHAR(50),
            Monto		                NUMERIC(18,2),
			MetodoId		            INT,
			Metodo						VARCHAR(50),
            GastoOperativoId			INT,        
			GastoOperativo				VARCHAR(50),

            -- Identificadores de llaves foraneas y textos originales en el JSON
            -- Despacho(Ticket)
            DespachoId                  BIGINT,
			Despacho					VARCHAR(200),

            -- Tipo Gasto
            TipoGastoId		            BIGINT,
            TipoGasto					VARCHAR(200),

            -- Colaboradores
            ColaboradorId				BIGINT,
            Colaborador					VARCHAR(150),
			ColaboradorAutorizadoId		BIGINT,
            ColaboradorAutorizado		VARCHAR(150),

            --
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),

            --Campos para mensaje
            RegistroValido              BIT DEFAULT 1,
            MotivoRechazo               VARCHAR(MAX)
        )

    -- 2. Valida que se tenga una cadena de texto JSON con información
        IF @ListaRegistrosDispersiones IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'No se ha enviado información de los Registros de dispersiones para almacenar';
                GOTO SALIDA;
            END;
        ELSE IF ISJSON(@ListaRegistrosDispersiones) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
                INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
                    VALUES('La información de los Registros de dispersiones no está en formato JSON esperado', 0);
                GOTO SALIDA;                
            END;

    -- 3. Inserta la información necesaria proveniente del JSON
        INSERT INTO #TablaTmp (
					DivisaMonto,
                    Monto,
                    Metodo,
                    GastoOperativo,
                    -- Textos de las llaves foráneas
                    Despacho,
                    Colaborador,
                    ColaboradorAutorizado,
					TipoGasto,
                    --
                    Usuario,
                    Trail)
            SELECT * FROM OPENJSON (@ListaRegistrosDispersiones)
                WITH
                (
					DivisaMonto					VARCHAR(50),
                    Monto                       NUMERIC(18,2),
                    Metodo			            VARCHAR(50),
                    GastoOperativo	            VARCHAR(50),

                    -- Textos de las llaves foráneas
                    Despacho                    VARCHAR(200),
                    Colaborador                 VARCHAR(200),
                    ColaboradorAutorizado       VARCHAR(150),
					TipoGasto					VARCHAR(100),
                    --
                    Usuario                     VARCHAR(150),
                    Trail						VARCHAR(MAX)
                )

	-- 3.1 Actualizar el valor de MetodoId y GastoOperativoId dependiendo de lo ingresado en el CSV
			--MetodoId
			-- Actualizar MetodoId a 1 cuando Metodo es "si" o "SI" (insensible a mayúsculas/minúsculas)
			UPDATE #TablaTmp
			SET MetodoId = 1
			WHERE UPPER(LTRIM(RTRIM(Metodo))) = 'DISPERSADO';

		-- Actualizar MetodoId a 0 cuando Metodo es "no" o "NO" (insensible a mayúsculas/minúsculas)
			UPDATE #TablaTmp
			SET MetodoId = 2
			WHERE UPPER(LTRIM(RTRIM(Metodo))) = 'NO DISPERSADO';

			--GastoOperativoId
			-- Actualizar MetodoId a 1 cuando Metodo es "si" o "SI" (insensible a mayúsculas/minúsculas)
			UPDATE #TablaTmp
			SET GastoOperativoId = 1
			WHERE UPPER(LTRIM(RTRIM(GastoOperativo))) = 'SI' OR UPPER(LTRIM(RTRIM(GastoOperativo))) = 'S?' ;

		-- Actualizar MetodoId a 0 cuando Metodo es "no" o "NO" (insensible a mayúsculas/minúsculas)
			UPDATE #TablaTmp
			SET GastoOperativoId = 2
			WHERE UPPER(LTRIM(RTRIM(GastoOperativo))) = 'NO';

			/*Si no coincide con alguno de estos textos es decir que hayan escrito cualquier otra cosa sera un registro invalido
			Por lo cual actualizaremos estos registros invalidos*/
			--Metodo invalido
			UPDATE #TablaTmp
				SET RegistroValido = 0,
				MotivoRechazo = #TablaTmp.Metodo + ' no es un valor valido para método en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
				WHERE MetodoId IS NULL
			--Gasto operativo invalido
			UPDATE #TablaTmp
				SET RegistroValido = 0,
				MotivoRechazo = #TablaTmp.GastoOperativo + ' no es un valor valido para gasto operativo en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
				WHERE GastoOperativoId IS NULL 
	

	-- 4.0 Asignaremos un valor de divisa entero dependiendo el texto insertado en el CSV
		-- Actualiza MonedaIdCosto basado en DivisaCosto
			UPDATE #TablaTmp
				SET 
					MonedaIdMonto = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(DivisaMonto))) = 'MXN' THEN 1
							WHEN UPPER(LTRIM(RTRIM(DivisaMonto))) = 'USD' THEN 2
							ELSE MonedaIdMonto  -- Para mantener el valor existente en otros casos
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
				ColaboradorId = CB_Colaborador.Id,
                ColaboradorAutorizadoId = CB_ColaboradorAutorizado.Id,
				TipoGastoId = CB_TipoGasto.Id,
            
                -- Actualiza el motivo de rechazo
                MotivoRechazo =
                    CASE
                        WHEN CB_Despacho.ManifiestoId IS NULL THEN 'El manifiesto "' + #TablaTmp.Despacho + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_Colaborador.Id IS NULL THEN 'El colaborador "' + #TablaTmp.Colaborador + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_ColaboradorAutorizado.Id IS NULL THEN 'El autorizador "' + #TablaTmp.ColaboradorAutorizado + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						WHEN CB_TipoGasto.Id IS NULL THEN 'El tipo de gasto "' + #TablaTmp.TipoGasto + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        ELSE #TablaTmp.MotivoRechazo END,
                -- Actualiza la bandera de RegistroValido
                RegistroValido = 
                    CASE
                        WHEN
                            CB_Despacho.Id IS NULL OR CB_Colaborador.Id IS NULL OR CB_ColaboradorAutorizado.Id IS NULL THEN 0
                        ELSE RegistroValido END

        FROM #TablaTmp  
        -- Despacho
            LEFT JOIN [Despachos].Visores CB_Despacho
                ON UPPER(LTRIM(RTRIM(CB_Despacho.Manifiesto))) = UPPER(LTRIM(RTRIM(#TablaTmp.Despacho)))
        -- Colaborador
            LEFT JOIN [Operadores].[Colaboradores] CB_Colaborador
                ON UPPER(LTRIM(RTRIM(CB_Colaborador.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Colaborador)))
        -- ColaboradorId
            LEFT JOIN [Operadores].[Colaboradores] CB_ColaboradorAutorizado
                ON UPPER(LTRIM(RTRIM(CB_ColaboradorAutorizado.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.ColaboradorAutorizado)))

		-- TipoGastoId
            LEFT JOIN [Despachos].[TipoGastos] CB_TipoGasto
                ON UPPER(LTRIM(RTRIM(CB_TipoGasto.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.TipoGasto)))



				
    -- 6.- Marca los registros en los que puede duplicarse la información

		UPDATE #TablaTmp
			SET RegistroValido = 0 , MotivoRechazo ='Se ha actualizado un registro duplicado (' + #TablaTmp.Despacho + '/' + #TablaTmp.TipoGasto+') en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' del archivo CSV'
			FROM #TablaTmp
			INNER JOIN (
				SELECT
					*,
					ROW_NUMBER() OVER (PARTITION BY DespachoId, TipoGastoId ORDER BY Linea DESC) AS rn
				FROM
					#TablaTmp
				WHERE
					RegistroValido = 1
			) AS Rep
			ON #TablaTmp.Linea = Rep.Linea
			WHERE Rep.rn != 1;

    -- 7.-  Inserta solo los registros que son correctos

	MERGE INTO [Despachos].[RegistrosDispersiones] AS TARGET
	USING #TablaTmp AS SOURCE
	ON TARGET.DespachoId = SOURCE.DespachoId AND TARGET.TipoGastoId = SOURCE.TipoGastoId
	WHEN MATCHED AND SOURCE.RegistroValido =1 THEN
	UPDATE SET
			--TARGET.DespachoId = SOURCE.DespachoId,
			TARGET.ColaboradorId = SOURCE.ColaboradorId,
			TARGET.MonedaIdMonto = SOURCE.MonedaIdMonto,
			TARGET.Monto = SOURCE.Monto,
			--TARGET.TipoGastoId = SOURCE.TipoGastoId,
			TARGET.MetodoId = SOURCE.MetodoId,
			TARGET.GastoOperativoId = SOURCE.GastoOperativoId,
			TARGET.ColaboradorAutorizadoId = SOURCE.ColaboradorAutorizadoId,
			TARGET.Usuario = SOURCE.Usuario,
			TARGET.Eliminado = 1,
			TARGET.Trail = SOURCE.Trail
		WHEN NOT MATCHED AND SOURCE.RegistroValido =1 THEN
		INSERT(
			DespachoId,
			ColaboradorId,
			MonedaIdMonto,
			Monto,
			TipoGastoId,
	        MetodoId,
			GastoOperativoId,
			ColaboradorAutorizadoId,
			Eliminado,
			Usuario,
			FechaCreacion,
			Trail
		) VALUES(
			DespachoId,
			ColaboradorId,
			MonedaIdMonto,
			Monto,
			TipoGastoId,
			MetodoId,
			GastoOperativoId,
			ColaboradorAutorizadoId,
			1,
			Usuario,
			CURRENT_TIMESTAMP,
			Trail);

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
