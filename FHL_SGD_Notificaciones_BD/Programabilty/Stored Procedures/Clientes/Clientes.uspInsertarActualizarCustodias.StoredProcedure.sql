USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspInsertarActualizarCustodias]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Diciembre 2023
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Clientes].[uspInsertarActualizarCustodias]
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
		Id bigint,
		Nombre varchar(200),
		TipoTarifa int,
		MonedaIdCosto int,
		Costo numeric(18, 2),
		MonedaIdCostoArmada int,
		CostoArmada numeric(18, 2),
		MonedaIdCostoNoArmada int,
		CostoNoArmada numeric(18, 2),
		MonedaIdValorMinimo int,
		ValorMinimoArmada numeric(18, 2),
		Origen varchar(5000),
		Destino varchar(5000),
		TipoCustodia varchar(500),
		Utilidad int,
		ProveedorId bigint,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id,
            Nombre,
            TipoTarifa,
            MonedaIdCosto,
            Costo,
            MonedaIdCostoArmada,
            CostoArmada,
            MonedaIdCostoNoArmada,
			CostoNoArmada,
			MonedaIdValorMinimo,
			ValorMinimoArmada,
			Origen,
			Destino,
			TipoCustodia,
			Utilidad,
			ProveedorId,
			Usuario,
			Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			Nombre varchar(200),
			TipoTarifa int,
			MonedaIdCosto int,
			Costo numeric(18, 2),
			MonedaIdCostoArmada int,
			CostoArmada numeric(18, 2),
			MonedaIdCostoNoArmada int,
			CostoNoArmada numeric(18, 2),
			MonedaIdValorMinimo int,
			ValorMinimoArmada numeric(18, 2),
			Origen varchar(5000),
			Destino varchar(5000),
			TipoCustodia varchar(500),
			Utilidad int,
			ProveedorId bigint,
			Usuario varchar(150),			
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Clientes].[Custodias](
				Nombre,
				TipoTarifa,
				MonedaIdCosto,
				Costo,
				MonedaIdCostoArmada,
				CostoArmada,
				MonedaIdCostoNoArmada,
				CostoNoArmada,
				MonedaIdValorMinimo,
				ValorMinimoArmada,
				Origen,
				Destino,
				TipoCustodia,
				Utilidad,
				ProveedorId,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail) SELECT
				Nombre,
				TipoTarifa,
				MonedaIdCosto,
				Costo,
				MonedaIdCostoArmada,
				CostoArmada,
				MonedaIdCostoNoArmada,
				CostoNoArmada,
				MonedaIdValorMinimo,
				ValorMinimoArmada,
				Origen,
				Destino,
				TipoCustodia,
				Utilidad,
				ProveedorId,
				Usuario,
				1,
				CURRENT_TIMESTAMP,
				Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Clientes].[Custodias]
				SET
					Nombre = tmp.Nombre,
					TipoTarifa = tmp.TipoTarifa,
					MonedaIdCosto = tmp.MonedaIdCosto,
					Costo = tmp.Costo,
					MonedaIdCostoArmada = tmp.MonedaIdCostoArmada,
					CostoArmada = tmp.CostoArmada,
					MonedaIdCostoNoArmada = tmp.MonedaIdCostoNoArmada,
					CostoNoArmada = tmp.CostoNoArmada,
					MonedaIdValorMinimo = tmp.MonedaIdValorMinimo,
					ValorMinimoArmada = tmp.ValorMinimoArmada,
					Origen = tmp.Origen,
					Destino = tmp.Destino,
					TipoCustodia = tmp.TipoCustodia,
					Utilidad = tmp.Utilidad,
					ProveedorId = tmp.ProveedorId,
					Usuario = tmp.Usuario,
					Eliminado = 1,
					Trail = tmp.Trail 
					FROM @Tablatemp tmp WHERE [Clientes].[Custodias].[Id] = tmp.[Id];

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
