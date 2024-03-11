USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarRegistrosAjustesCSV]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










-- =============================================
-- Author:      NewlandApps
-- Create date: Septiembre de 2023
-- Description: Inserta una lista de registros de ajustes pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarRegistrosAjustesCSV]
    -- Add the parameters for the stored procedure here
    @ListaRegistrosAjustesJson         VARCHAR(MAX) = NULL
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
            Monto						NUMERIC(18,2),

			Metodo						VARCHAR(50),
            MetodoId                    INT,
          
            -- Identificadores de llaves foraneas y textos originales en el JSON
            -- Despachos
            DespachoId					BIGINT,
            Despacho					VARCHAR(150),
            -- Colaboradores
            ColaboradorId				BIGINT,
            Colaborador					VARCHAR(150),

            --
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),

            --Campos para mensaje
            RegistroValido              BIT DEFAULT 1,
            MotivoRechazo               VARCHAR(MAX)
        )

    -- 2. Valida que se tenga una cadena de texto JSON con información
        IF @ListaRegistrosAjustesJson IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'No se ha enviado información de los Registros de ajustes para almacenar';
                GOTO SALIDA;
            END;
        ELSE IF ISJSON(@ListaRegistrosAjustesJson) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
                INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
                    VALUES('La información de los Registros de ajustes no está en formato JSON esperado', 0);
                GOTO SALIDA;                
            END;

    -- 3. Inserta la información necesaria proveniente del JSON
        INSERT INTO #TablaTmp (
					DivisaMonto,
                    Monto,
                    Metodo,                    
                    -- Textos de las llaves foráneas
                    Despacho,
                    Colaborador,
                    --
                    Usuario,
                    Trail)
            SELECT * FROM OPENJSON (@ListaRegistrosAjustesJson)
                WITH
                (
					DivisaMonto					VARCHAR(50),
                    Monto		                NUMERIC(18,2),
                    Metodo						VARCHAR(50),                  
                    -- Textos de las llaves foráneas
                    Despacho                    VARCHAR(200),
                    Colaborador					VARCHAR(200),                   
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


		



	-- 4.2 Asignaremos un valor de metodo dependiendo el texto insertado en el CSV
		-- Actualiza MetodoId basado en lo ingresado en Método en el CSV
			UPDATE #TablaTmp
				SET 
					MetodoId = 
						CASE 
							WHEN UPPER(LTRIM(RTRIM(Metodo))) = 'EFECTIVO' THEN 0
							WHEN UPPER(LTRIM(RTRIM(Metodo))) = 'NOMINA' THEN 1
							WHEN UPPER(LTRIM(RTRIM(Metodo))) = 'N?MINA' THEN 1
							WHEN UPPER(LTRIM(RTRIM(Metodo))) = 'NO RECUPERABLE' THEN 2
							ELSE MetodoId  -- Para mantener el valor existente en otros casos
						END
				WHERE 
					UPPER(LTRIM(RTRIM(Metodo))) IN ('EFECTIVO', 'NOMINA', 'N?MINA', 'NO RECUPERABLE');

	--4.3 Crearemos los registros invalidos para los casos en los que se haya ingresado incorrectamente el texto para el método
		UPDATE #TablaTmp
			SET	
				--Actualizamos el motivo de rechazo
				MotivoRechazo =
					CASE
						WHEN MetodoId IS NULL THEN 'El método "' + #TablaTmp.Metodo + '" es incorrecto (EFECTIVO/NOMINA/NO RECUPERABLE) en la línea '  + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
						ELSE #TablaTmp.MotivoRechazo END,
				--
				RegistroValido = 
                    CASE
                        WHEN
                            MetodoId IS NULL THEN 0
                        ELSE RegistroValido END






    -- 5. Reemplaza los textos por los identificadores correspondientes en las llaves foráneas y solo de aquellos registros
    -- que son únicos ya que los vehículos que fueron excluidos (RegistroValido = 0) no serán guardados
        UPDATE #TablaTmp
            SET
                DespachoId = CB_Despacho.ManifiestoId,
                ColaboradorId = CB_Colaborador.Id,
            
                -- Actualiza el motivo de rechazo
                MotivoRechazo =
                    CASE
                        WHEN CB_Despacho.ManifiestoId IS NULL THEN 'El manifiesto "' + #TablaTmp.Despacho + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        WHEN CB_Colaborador.Id IS NULL THEN 'El colaborador "' + #TablaTmp.Colaborador + '" no ha sido encontrado ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        ELSE #TablaTmp.MotivoRechazo END,
                -- Actualiza la bandera de RegistroValido
                RegistroValido = 
                    CASE
                        WHEN
                            CB_Despacho.Id IS NULL OR CB_Colaborador.Id IS NULL THEN 0
                        ELSE RegistroValido END

        FROM #TablaTmp  
        -- Despachos(Ticket)
            LEFT JOIN Despachos.Visores CB_Despacho
                ON UPPER(LTRIM(RTRIM(CB_Despacho.Manifiesto))) = UPPER(LTRIM(RTRIM(#TablaTmp.Despacho)))
        -- Colaborador
            LEFT JOIN Operadores.Colaboradores CB_Colaborador
                ON UPPER(LTRIM(RTRIM(CB_Colaborador.Nombre))) = UPPER(LTRIM(RTRIM(#TablaTmp.Colaborador)))



	-- 6.- Quitamos registros duplicados
		UPDATE #TablaTmp
			SET RegistroValido = 0 , MotivoRechazo ='Se ha actualizado un registro duplicado (' + #TablaTmp.Despacho + '/' + #TablaTmp.Colaborador+') en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' del archivo CSV'
			FROM #TablaTmp
			INNER JOIN (
				SELECT
					*,
					ROW_NUMBER() OVER (PARTITION BY DespachoId, ColaboradorId ORDER BY Linea DESC) AS rn
				FROM
					#TablaTmp
				WHERE
					RegistroValido = 1
			) AS Rep
			ON #TablaTmp.Linea = Rep.Linea
			WHERE Rep.rn != 1;
			


    -- 7.-  Inserta solo los registros que son correctos
	
	MERGE INTO Despachos.RegistroAjuste AS TARGET
		--Realizamos una consulta interna para ordenar el ultimo registro con la misma Referencia encontrado en el CSV
		USING #TablaTmp AS SOURCE
		ON TARGET.DespachoId = SOURCE.DespachoId AND TARGET.ColaboradorId = SOURCE.ColaboradorId
		--Se solicita que source.rn=1 por que necesitamos sea el primer registro que previamente se acomodo de forma descendente
		WHEN MATCHED AND SOURCE.RegistroValido = 1 THEN
			UPDATE SET
				--TARGET.DespachoId = SOURCE.DespachoId,
				--TARGET.ColaboradorId = SOURCE.ColaboradorId,
				TARGET.MonedaIdMonto = SOURCE.MonedaIdMonto,
				TARGET.Monto = SOURCE.Monto,
				TARGET.MetodoId = SOURCE.MetodoId,
				TARGET.Usuario = SOURCE.Usuario,
				TARGET.Eliminado = 1,
				TARGET.Trail = SOURCE.Trail
		WHEN NOT MATCHED AND SOURCE.RegistroValido = 1 THEN
			INSERT (
				DespachoId,
				ColaboradorId,
				MonedaIdMonto,
				Monto,
				MetodoId,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			)
			VALUES (
				SOURCE.DespachoId,
				SOURCE.ColaboradorId,
				SOURCE.MonedaIdMonto,
				SOURCE.Monto,
				SOURCE.MetodoId,
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
