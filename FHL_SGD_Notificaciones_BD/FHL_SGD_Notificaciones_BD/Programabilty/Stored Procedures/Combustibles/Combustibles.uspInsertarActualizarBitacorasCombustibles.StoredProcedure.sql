USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspInsertarActualizarBitacorasCombustibles]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Combustibles].[uspInsertarActualizarBitacorasCombustibles]
--Parametros necesarios para la ejecución correcta
	 @Lista VARCHAR(MAX) = null
AS
BEGIN
	--Variables de control
	DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = NULL;
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT = 0;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT = 0;

	DECLARE @ControlRegistros TABLE (IdInsertados bigint, IdActualizados bigint); --Tabla en la cual guardaremos los Id insertados y su relación


    -- 1. Valida que se tenga una cadena de texto JSON con información
	IF(@Lista is null)
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se han recibido registros a insertar o actualizar';
			GOTO SALIDA;
		END;
        ELSE IF ISJSON(@Lista) = 0
            BEGIN
                -- La información pasada como parámetro no es una cadena JSON válida
                SET @Resultado = -2;
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
			Trail) SELECT * FROM OPENJSON(@Lista)
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

		
		-- 4. Instrucción para insertar registros nuevos
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

			-- 7. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;
		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error para guardar los registros';
			ROLLBACK;
		END CATCH


		-- 8. Se validara que se insertaron o actualizaron la misma cantidad de registros que se enviaron
		IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM @Tablatemp))
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'Los registros se guardaron correctamente.';
		END
		ELSE
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error para guardar los registros';
		END

	--Devuelve el resultado de la inserción o actualización de los registros enviados
	SALIDA:
		SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
