USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarRegistrosProveedoresCSV]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:      NewlandApps
-- Create date: Septiembre de 2023
-- Description: Inserta una lista de registros de casetas pasados como parámetros en formato JSON
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarRegistrosProveedoresCSV]
    -- Add the parameters for the stored procedure here
    @ListaRegistrosProveedores         VARCHAR(MAX) = NULL
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
            
			-- Identificadores de llaves foraneas y textos originales en el JSON
            -- Despachos
            DespachoId					BIGINT,
            Despacho					VARCHAR(150),

			--
			Nombre						VARCHAR(500),
			RFC							VARCHAR(50),
			CorreoElectronico			VARCHAR(50),
			NumeroCelular				VARCHAR(50),

            --
			Usuario						VARCHAR(150),
			Trail						VARCHAR(MAX),

            --Campos para mensaje
            RegistroValido              INT DEFAULT 1,
            MotivoRechazo               VARCHAR(MAX)
        )

    -- 2. Valida que se tenga una cadena de texto JSON con información
        IF @ListaRegistrosProveedores IS NULL
            BEGIN
                SET @Resultado = -1;
                SET @Mensaje = 'No se ha enviado información de los Registros de ajustes para almacenar';
                GOTO SALIDA;
            END;
        ELSE IF ISJSON(@ListaRegistrosProveedores) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
                INSERT INTO #TablaTmp (MotivoRechazo, RegistroValido)
                    VALUES('La información de los Registros de ajustes no está en formato JSON esperado', 0);
                GOTO SALIDA;                
            END;

    -- 3. Inserta la información necesaria proveniente del JSON
        INSERT INTO #TablaTmp (
					-- Textos de las llaves foráneas
					Despacho,
					--
                    Nombre,
					RFC,
					CorreoElectronico,
					NumeroCelular,
                    --
                    Usuario,
                    Trail)
            SELECT * FROM OPENJSON (@ListaRegistrosProveedores)
                WITH
                (
					-- Textos de las llaves foráneas
                    Despacho                    VARCHAR(200),
					--
					Nombre						VARCHAR(500),
					RFC							VARCHAR(50),
					CorreoElectronico			VARCHAR(50),
                    NumeroCelular		        VARCHAR(50),
                    --
                    Usuario                     VARCHAR(150),
                    Trail						VARCHAR(MAX)
                )


    -- 4. Reemplaza los textos por los identificadores correspondientes en las llaves foráneas y solo de aquellos registros
    -- que son únicos ya que los vehículos que fueron excluidos (RegistroValido = 0) no serán guardados
        UPDATE #TablaTmp
            SET
                DespachoId = CB_Despacho.ManifiestoId,
            
                -- Actualiza el motivo de rechazo
                MotivoRechazo =
                    CASE
                        WHEN CB_Despacho.ManifiestoId IS NULL THEN 'El manifiesto "' + #TablaTmp.Despacho + '" no ha sido encontrado en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX))
                        ELSE #TablaTmp.MotivoRechazo END,
                -- Actualiza la bandera de RegistroValido
                RegistroValido = 
                    CASE
                        WHEN
                            CB_Despacho.Id IS NULL THEN 0
                        ELSE RegistroValido END

        FROM #TablaTmp  
        -- Despachos(Ticket)
            LEFT JOIN Despachos.Visores CB_Despacho
                ON UPPER(LTRIM(RTRIM(CB_Despacho.Manifiesto))) = UPPER(LTRIM(RTRIM(#TablaTmp.Despacho)))


	-- 5. Marca los registros en los que puede duplicarse la información proveniente del CSV
			UPDATE #TablaTmp
			SET RegistroValido = 0 , MotivoRechazo ='Se ha actualizado un registro duplicado (' + #TablaTmp.Nombre +'/'+#TablaTmp.Despacho+') en la línea ' + CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' del archivo CSV'
			FROM #TablaTmp
			INNER JOIN (
				SELECT
					*,
					ROW_NUMBER() OVER (PARTITION BY UPPER(LTRIM(RTRIM(Nombre))), Despacho ORDER BY Linea DESC) AS rn
				FROM
					#TablaTmp
				WHERE
					RegistroValido = 1
			) AS Rep
			ON #TablaTmp.Linea = Rep.Linea
			WHERE Rep.rn != 1;



	--5.1 Revisar los correos electrónicos ingresados en el csv
		UPDATE #TablaTmp
		SET RegistroValido = 0, MotivoRechazo='El correo '+ #TablaTmp.CorreoElectronico+ ' en la línea '+ CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' no es un correo valido'
		FROM #TablaTmp
		WHERE CorreoElectronico NOT LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%'

	--5.2 Revisar los RFC ingresados en el csv
		/*UPDATE #TablaTmp
		SET RegistroValido = 0, MotivoRechazo='El RFC '+ #TablaTmp.RFC+ ' en la línea '+ CAST(#TablaTmp.Linea AS VARCHAR(MAX)) + ' no es un RFC valido'
		FROM #TablaTmp
		WHERE RFC NOT LIKE '%[A-Z&Ññ]{3,4}\d{6}[A-V0-9]{0,3}%'*/



    -- 6.-  Inserta y actualiza solo los registros que son correctos

	MERGE INTO Despachos.RegistroProveedores AS TARGET
		--Realizamos una consulta interna para ordenar el ultimo registro con la misma Referencia encontrado en el CSV
		USING #TablaTmp AS SOURCE
		ON UPPER(LTRIM(RTRIM(TARGET.Nombre))) = UPPER(LTRIM(RTRIM(SOURCE.Nombre))) AND TARGET.DespachoId = SOURCE.DespachoId 
		--Se solicita que source.rn=1 por que necesitamos sea el primer registro que previamente se acomodo de forma descendente
		WHEN MATCHED AND SOURCE.RegistroValido = 1 THEN
			UPDATE SET
				--TARGET.DespachoId = SOURCE.DespachoId,
				--TARGET.Nombre = SOURCE.Nombre,
				TARGET.RFC = SOURCE.RFC,
				TARGET.CorreoElectronico = SOURCE.CorreoElectronico,
				TARGET.NumeroCelular = SOURCE.NumeroCelular,
				TARGET.Usuario = SOURCE.Usuario,
				TARGET.Eliminado = 1,
				TARGET.Trail = SOURCE.Trail
		WHEN NOT MATCHED AND SOURCE.RegistroValido = 1 THEN
			INSERT (
				DespachoId,
				Nombre,
				RFC,
				CorreoElectronico,
				NumeroCelular,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			)
			VALUES (
				SOURCE.DespachoId,
				SOURCE.Nombre,
				SOURCE.RFC,
				SOURCE.CorreoElectronico,
				SOURCE.NumeroCelular,
				SOURCE.Usuario,
				1,
				CURRENT_TIMESTAMP,
				SOURCE.Trail
			);


    -- 7. Recupera las estadisticas y la lista de mensajes para informar lo sucedido en la ejeción del SP
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
