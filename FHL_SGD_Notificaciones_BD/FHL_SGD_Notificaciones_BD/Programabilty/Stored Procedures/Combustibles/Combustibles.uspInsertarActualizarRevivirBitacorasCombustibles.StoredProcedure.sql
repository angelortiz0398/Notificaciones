USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspInsertarActualizarRevivirBitacorasCombustibles]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Combustibles].[uspInsertarActualizarRevivirBitacorasCombustibles]
	--Parametros necesarios para la ejecución correcta
	 @Json VARCHAR(MAX) = null
AS
BEGIN
	--Variables de control
	DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = NULL;
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT = 0;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT = 0;
	-- Variable para controlar si reactivamos un registro eliminado virtualmente
	DECLARE @Revivido BIT = 0;

	--Lista de errores:
	-- -5 : JSON nullo
	-- -4 : Formato no validó "JSON"
	-- -3 : Error al guardar los registros	
	-- -2 : Error Crear-> Registro ya existente
	-- -1 : Error : Actualizar-> Registro ya existente
	--  0 : Error-> Registro (Factura) ya había sido utilizado
	--  1 : Creado-> Registro creado corrrectamente
	--  2 : Actualizar-> Registro actualizado correctamente

    -- 1. Valida que se tenga una cadena de texto JSON con información
	IF(@Json is null)
		BEGIN
			SET @Resultado = -5;
			SET @Mensaje = 'No se han recibido registros a insertar o actualizar';
			GOTO SALIDA;
		END;
        ELSE IF ISJSON(@Json) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -4;
				SET @Mensaje = 'La información recibida no está en formato JSON esperado';
                GOTO SALIDA;                
            END;
-- 2. Creación de la tabla temporal
	DECLARE @Tablatemp TABLE (
		[Id] [BIGINT]NULL,
		[FechaRegistro] [DATETIME]NULL,
		[FechaCarga] [DATETIME]NULL,
		[Combustible] [VARCHAR](50)NULL,
		[Factura] [VARCHAR](50)NULL,
		[OdometroActual] [NUMERIC](18,2)NULL,
		[OdometroAnterior] [NUMERIC](18,2)NULL,
		[Litros] [NUMERIC](18,2)NULL,
		[MonedaIdCosto] [INT]NULL,
		[Costo] [NUMERIC](18,2)NULL,
		[RendimientoCalculado] [numeric](18,2)NULL,
		[MonedaIdCostoTotal] [int]NULL,
		[CostoTotal] [NUMERIC](18,2),
		[MonedaIdIVA] [INT]NULL,
		[IVA] [NUMERIC](18,2),
		[MonedaIdIEPS] [INT]NULL,
		[IEPS] [NUMERIC](18,2),
		[Comentario] [VARCHAR](250)NULL,
		[Duracion] [TIME](7)NULL,
		[Referencia] [VARCHAR](250),
		[VehiculosId] [BIGINT]NULL,
		[TiposCombustiblesId] [BIGINT]NULL,
		[EstacionesId] [BIGINT]NULL,
		[ColaboradoresId] [BIGINT]NULL,
		[Usuario] [VARCHAR](150)NULL,
		[Eliminado] [BIT]NULL,
		[FechaCreacion] [DATETIME]NULL,
		[Trail] [VARCHAR](MAX));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id,
            FechaRegistro,
			FechaCarga,
			Combustible,
			Factura,
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
			Referencia,
			VehiculosId,
			TiposCombustiblesId,
			EstacionesId,
			ColaboradoresId,
			Usuario,
			Trail) SELECT * FROM OPENJSON(@Json)
			WITH(
			Id BIGINT,
			FechaRegistro DATETIME,
			FechaCarga DATETIME,
			Combustible VARCHAR,
			Factura VARCHAR(50),
			OdometroActual NUMERIC(18,2),
			OdometroAnterior NUMERIC(18,2),
			Litros NUMERIC(18,2),
			MonedaIdCosto INT,
			Costo NUMERIC(18,2),
			RendimientoCalculado numeric(18,2),
			MonedaIdCostoTotal int,
			CostoTotal NUMERIC(18,2),
			MonedaIdIVA INT,
			IVA NUMERIC(18,2),
			MonedaIdIEPS INT,
			IEPS NUMERIC(18,2),
			Comentario VARCHAR (250),
			Duracion TIME(7),
			Referencia VARCHAR(250),
			VehiculosId BIGINT,
			TiposCombustiblesId BIGINT,
			EstacionesId BIGINT,
			ColaboradoresId BIGINT,
			Usuario varchar(150),
			Trail varchar(max));

	--4. Error al CREAR -> Validaremos que no sea un registro existente
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Combustibles].[BitacorasCombustibles] BitacoraCombustible
				ON LOWER(LTRIM(RTRIM(temp.Factura))) = LOWER(LTRIM(RTRIM(BitacoraCombustible.Factura)))
				WHERE temp.Id = 0 AND BitacoraCombustible.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -2;
				SET @Mensaje = 'Actualmente existe un registro con ese "Factura"';
				GOTO Salida;
			END;

	--5. Error al ACTUALIZAR -> Validaremos que no exista un registro con ese Factura
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Combustibles].[BitacorasCombustibles] BitacoraCombustible
				ON LOWER(LTRIM(RTRIM(temp.Factura))) = LOWER(LTRIM(RTRIM(BitacoraCombustible.Factura))) 
				WHERE temp.Id != BitacoraCombustible.Id AND BitacoraCombustible.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -1;
				SET @Mensaje = 'Actualmente existe un registro con ese "Factura"';
				GOTO Salida;
			END;
		
	--6. Marcar registros que ya se utilizaron facturas -> Se le asignara el Id de un registro eliminado si ya existia el Factura en un registro anterior
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Combustibles].[BitacorasCombustibles] BitacoraCombustible
				ON LOWER(LTRIM(RTRIM(temp.Factura))) = LOWER(LTRIM(RTRIM(BitacoraCombustible.Factura))) 
				WHERE temp.Id = 0 AND BitacoraCombustible.Eliminado = 0)
			BEGIN				
				--Modificamos los mensajes y el resultado
				SET @Resultado = 0;
				SET @Mensaje = 'Previamente existió un registro con esa "Factura"';
				GOTO Salida;
			END;



		-- 7. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Combustibles].[BitacorasCombustibles](
				FechaRegistro,
				FechaCarga,
				Combustible,
				Factura,
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
				Referencia,
				VehiculosId,
				TiposCombustiblesId,
				EstacionesId,
				ColaboradoresId,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail) SELECT
				FechaRegistro,
				FechaCarga,
				Combustible,
				Factura,
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
				Referencia,
				VehiculosId,
				TiposCombustiblesId,
				EstacionesId,
				ColaboradoresId,
				Usuario,
				1,
				CURRENT_TIMESTAMP,
				Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Combustibles].[BitacorasCombustibles]
				SET
					FechaRegistro = tmp.FechaRegistro,
					FechaCarga = tmp.FechaCarga,
					Combustible = tmp.Combustible,
					Factura = tmp.Factura,
					OdometroActual = tmp.OdometroActual,
					OdometroAnterior = tmp.OdometroAnterior,
					Litros = tmp.Litros,
					MonedaIdCosto = tmp.MonedaIdCosto,
					Costo = tmp.COsto,
					RendimientoCalculado = tmp.RendimientoCalculado,
					MonedaIdCostoTotal = tmp.MonedaIdCostoTotal,
					CostoTotal = tmp.CostoTotal,
					MonedaIdIVA = tmp.MonedaIdIVA,
					IVA = tmp.IVA,
					MonedaIdIEPS = tmp.MonedaIdIEPS,
					IEPS = tmp.IEPS,
					Comentario = tmp.Comentario,
					Duracion = tmp.Duracion,
					Referencia = tmp.Referencia,
					VehiculosId = tmp.VehiculosId,
					TiposCombustiblesId = tmp.VehiculosId,
					EstacionesId = tmp.EstacionesId,
					ColaboradoresId = tmp.ColaboradoresId,
					Usuario = tmp.Usuario,
					Eliminado = 1,
					Trail = tmp.Trail 
					FROM @Tablatemp tmp WHERE [Combustibles].[BitacorasCombustibles].[Id] = tmp.[Id];

			-- 10. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;
		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -3;
			SET @Mensaje = 'Ocurrió un error al guardar el registro';
			ROLLBACK;
		END CATCH


		--11. Si no han ocurrido errores modificaremos los mensajes dependiendo
			--si se creó o actualizo un registro
			IF(@RegistrosInsertados > 0 AND @Revivido = 0)
				BEGIN
					SET @Resultado = 1;
					SET @Mensaje = 'Registro creado correctamente.';
				END
			IF(@RegistrosActualizados > 0 AND @Revivido = 0)
				BEGIN
					SET @Resultado = 2;
					SET @Mensaje = 'Registro actualizado correctamente.';
				END
		

	--Devuelve el resultado de la inserción o actualización de los registros enviados
	SALIDA:
		SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
