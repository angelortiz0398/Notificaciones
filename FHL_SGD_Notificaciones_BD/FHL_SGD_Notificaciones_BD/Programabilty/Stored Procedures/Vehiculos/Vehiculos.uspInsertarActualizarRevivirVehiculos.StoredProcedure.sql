USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspInsertarActualizarRevivirVehiculos]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros con validacion de repetidos
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspInsertarActualizarRevivirVehiculos]
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
	-- Variable para controlar el registro 
	DECLARE @NuevoID  BIGINT = NULL;
	--Variable para conseguir los Grupo Id del vehículo
	DECLARE @jsonGrupo VARCHAR(500);

	--Lista de errores:
	-- -5 : JSON nullo
	-- -4 : Formato no validó "JSON"
	-- -3 : Error al guardar los registros	
	-- -2 : Error Crear-> Registro ya existente
	-- -1 : Error : Actualizar-> Registro ya existente
	--  0 : Revivir-> Registro creado corrrectamente
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
		Id bigint NULL,
		Placa varchar(50) NULL,
		Economico varchar(150) NULL,
		Vin varchar(50) NULL,
		MarcaId bigint NULL,
		ModeloId bigint NULL,
		Anio int NULL,
		ColorId bigint NULL,
		TipoCombustibleId bigint NULL,
		TanqueCombustible int NULL,
		RendimientoMixto numeric(18, 2) NULL,
		RendimientoUrbano numeric(18, 2) NULL,
		RendimientoSuburbano numeric(18, 2) NULL,
		CapacidadVolumen int NULL,
		CapacidadVolumenEfectivo int NULL,
		ProveedorId bigint NULL,
		EsquemaId bigint NULL,
		Factura varchar(150) NULL,
		FacturaCarrocero varchar(150) NULL,
		GrupoVehiculo varchar(3000) NULL,
		ProveedorSeguroId bigint NULL,
		PolizaSeguro varchar(50) NULL,
		Inciso int NULL,
		Prima numeric(18, 2) NULL,
		NumPermiso varchar(150) NULL,
		TipoPermiso varchar(50) NULL,
		ConfiguracionId bigint NULL,
		HabilidadVehiculos varchar(5000) NULL,
		TipoId bigint NULL,
		ColaboradorId bigint NULL,
		RangoOperacion varchar(3000) NULL,
		Maniobras int NULL,
		Un varchar(5000) NULL,
		Motor varchar(50) NULL,
		FactorCo2 numeric(18, 2) NULL,
		TagCaseta varchar(50) NULL,
		UltimoOdometro numeric(18, 2) NULL,
		Estado bit NULL,
		Usuario varchar(150) NULL,
		Eliminado bit NULL,
		FechaCreacion datetime NULL,
		Trail varchar(max) NULL
		);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
	INSERT INTO @Tablatemp(
			Id,
			Placa,
			Economico,
			Vin,
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
			Un,
			Motor,
			FactorCo2,
			TagCaseta,
			UltimoOdometro,
			Estado,
			Usuario,
			Eliminado,
			FechaCreacion,
			Trail
							)
	   SELECT * FROM OPENJSON(@Json)
			WITH(
			Id bigint,
			Placa varchar(50),
			Economico varchar(150),
			Vin varchar(50),
			MarcaId bigint,
			ModeloId bigint,
			Anio int,
			ColorId bigint,
			TipoCombustibleId bigint,
			TanqueCombustible int,
			RendimientoMixto numeric(18, 2),
			RendimientoUrbano numeric(18, 2),
			RendimientoSuburbano numeric(18, 2),
			CapacidadVolumen int,
			CapacidadVolumenEfectivo int,
			ProveedorId bigint,
			EsquemaId bigint,
			Factura varchar(150),
			FacturaCarrocero varchar(150),
			GrupoVehiculo varchar(3000),
			ProveedorSeguroId bigint,
			PolizaSeguro varchar(50),
			Inciso int,
			Prima numeric(18, 2),
			NumPermiso varchar(150),
			TipoPermiso varchar(50),
			ConfiguracionId bigint,
			HabilidadVehiculos varchar(5000),
			TipoId bigint,
			ColaboradorId bigint,
			RangoOperacion varchar(3000),
			Maniobras int,
			Un varchar(5000),
			Motor varchar(50),
			FactorCo2 numeric(18, 2),
			TagCaseta varchar(50),
			UltimoOdometro numeric(18, 2),
			Estado bit,
			Usuario varchar(150),
			Eliminado bit,
			FechaCreacion datetime,
			Trail varchar(max)
					);
	
	--4. Error al CREAR -> Validaremos que no sea un registro existente
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Vehiculos].[Vehiculos] Vehiculo
				ON LOWER(LTRIM(RTRIM(temp.Economico))) = LOWER(LTRIM(RTRIM(Vehiculo.Economico))) OR
					LOWER(LTRIM(RTRIM(temp.Placa))) = LOWER(LTRIM(RTRIM(Vehiculo.Placa))) OR
					LOWER(LTRIM(RTRIM(temp.VIN))) = LOWER(LTRIM(RTRIM(Vehiculo.VIN)))
				WHERE temp.Id = 0 AND Vehiculo.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -2;
				SET @Mensaje = 'Actualmente existe un registro con la "Placa, Factura ó VIN" que intentas crear';
				GOTO Salida;
			END;

	--5. Error al ACTUALIZAR -> Validaremos que no exista un registro con ese nombre
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Vehiculos].[Vehiculos] Vehiculo
				ON  LOWER(LTRIM(RTRIM(temp.Economico))) = LOWER(LTRIM(RTRIM(Vehiculo.Economico))) OR
					LOWER(LTRIM(RTRIM(temp.Placa))) = LOWER(LTRIM(RTRIM(Vehiculo.Placa))) OR
					LOWER(LTRIM(RTRIM(temp.VIN))) = LOWER(LTRIM(RTRIM(Vehiculo.VIN)))
				WHERE temp.Id != Vehiculo.Id AND Vehiculo.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -1;
				SET @Mensaje = 'Actualmente existe un registro con ese la "Placa, Factura ó VIN" que intentas actualizar';
				GOTO Salida;
			END;
		
	--6. REVIVIR -> Se le asignara el Id de un registro eliminado si ya existia el Nombre en un registro anterior
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Vehiculos].[Vehiculos] Vehiculo
				ON LOWER(LTRIM(RTRIM(temp.Factura))) = LOWER(LTRIM(RTRIM(Vehiculo.Factura))) AND
				   LOWER(LTRIM(RTRIM(temp.Placa))) = LOWER(LTRIM(RTRIM(Vehiculo.Placa))) AND
				   LOWER(LTRIM(RTRIM(temp.VIN))) = LOWER(LTRIM(RTRIM(Vehiculo.VIN)))
				WHERE temp.Id = 0 AND Vehiculo.Eliminado = 0)
			BEGIN
				--Le modificamos el Id al registro recibido
				UPDATE temp SET temp.Id = Vehiculo.Id FROM @Tablatemp temp
				INNER JOIN [Vehiculos].[Vehiculos] Vehiculo
				ON LOWER(LTRIM(RTRIM(temp.Factura))) = LOWER(LTRIM(RTRIM(Vehiculo.Factura))) AND
				   LOWER(LTRIM(RTRIM(temp.Placa))) = LOWER(LTRIM(RTRIM(Vehiculo.Placa))) AND
				   LOWER(LTRIM(RTRIM(temp.VIN))) = LOWER(LTRIM(RTRIM(Vehiculo.VIN)))
				WHERE temp.Id = 0 AND Vehiculo.Eliminado = 0;

				--Modificamos los mensajes y el resultado ademas de encender la bandera de revivido
				SET @Revivido = 1;
				SET @Resultado = 0;
				SET @Mensaje = 'Registro reactivado correctamente';
			END;



		-- 7. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Vehiculos].[Vehiculos]
			(
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
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail
			)
				 SELECT
					Placa,
					Economico,
					Vin,
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
					Usuario,
					1,
					CURRENT_TIMESTAMP,
					Trail
				FROM @Tablatemp WHERE Id = 0;
			-- 8. Almacena la cantidad de registros insertados
				SET @NuevoID = SCOPE_IDENTITY();
			-- 9. Recupera el ID del registro insertado
				SET @RegistrosInsertados = @@ROWCOUNT;

				print @NuevoID;
			-- 10. Instrucción para actualizar registros
			UPDATE [Vehiculos].[Vehiculos]
				SET
					Placa = tmp.Placa,
					Economico = tmp.Economico,
					VIN = tmp.Vin,
					MarcaId = tmp.MarcaId,
					ModeloId = tmp.ModeloId,
					Anio = tmp.Anio,
					ColorId = tmp.ColorId,
					TipoCombustibleId = tmp.TipoCombustibleId,
					TanqueCombustible = tmp.TanqueCombustible,
					RendimientoMixto = tmp.RendimientoMixto,
					RendimientoUrbano = tmp.RendimientoUrbano,
					RendimientoSuburbano = tmp.RendimientoSuburbano,
					CapacidadVolumen = tmp.CapacidadVolumen,
					CapacidadVolumenEfectivo = tmp.CapacidadVolumenEfectivo,
					ProveedorId = tmp.ProveedorId,
					EsquemaId = tmp.EsquemaId,
					Factura = tmp.Factura,
					FacturaCarrocero = tmp.FacturaCarrocero,
					GrupoVehiculo = tmp.GrupoVehiculo,
					ProveedorSeguroId = tmp.ProveedorSeguroId,
					PolizaSeguro = tmp.PolizaSeguro,
					Inciso = tmp.Inciso,
					Prima = tmp.Prima,
					NumPermiso = tmp.NumPermiso,
					TipoPermiso = tmp.TipoPermiso,
					ConfiguracionId = tmp.ConfiguracionId,
					HabilidadVehiculos = tmp.HabilidadVehiculos,
					TipoId = tmp.TipoId,
					ColaboradorId = tmp.ColaboradorId,
					RangoOperacion = tmp.RangoOperacion,
					Maniobras = tmp.Maniobras,
					UN = tmp.UN,
					Motor = tmp.Motor,
					FactorCO2 = tmp.FactorCO2,
					TagCaseta = tmp.TagCaseta,
					UltimoOdometro = tmp.UltimoOdometro,
					Estado = tmp.Estado,
					Usuario = tmp.Usuario
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE [Vehiculos].[Vehiculos].[Id] = tmp.[Id];


			-- 11. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;


			--12. Declaramos una tabla para controlar los registros a insertar en la tabla GrupoDetalle
			DECLARE @TablaGrupoTemp TABLE( 
					GrupoId bigint,
					VehiculoId bigint,
					Usuario varchar(150),
					Trail varchar(max))

			--13. Obtendremos los Id referenciados a la tabla Vehículos.Grupos
				-- Guardamos el json en una variable
					SELECT @jsonGrupo = GrupoVehiculo
					FROM @Tablatemp; 
				-- Utilizamos la variable previamente creada para asi insertar los Id de grupos en los Json
					INSERT INTO @TablaGrupoTemp(GrupoId)
					SELECT * FROM OPENJSON (@jsonGrupo) WITH 
					(id bigint
					)

			--14. Insertamos tanto trail como usuario referenciales a la 
			update @TablaGrupoTemp 
			set Trail = Temp.Trail,
				Usuario = Temp.Usuario
			from @Tablatemp Temp

			-- 15. Insertaremos a la tabla Grupo detalles 
				--Actualización de un vehículo
				IF(@NuevoID is null)
					BEGIN

						--Eliminamos los registros asociados al vehiculo
						DELETE GD
						FROM [Vehiculos].[GruposDetalles] GD
						INNER JOIN @Tablatemp Temp ON GD.VehiculoId = Temp.Id;

						--Actualizamos nuestra tabla temporal de grupos detalles a insertar
						update @TablaGrupoTemp set VehiculoId = Temp.Id FROM @Tablatemp Temp

						-- Inserción
						Insert into Vehiculos.GruposDetalles(
							GrupoId,
							VehiculoId,
							Usuario,
							Eliminado,
							FechaCreacion,
							Trail
						)SELECT
							GrupoId,
							VehiculoId,
							Usuario,
							1,
							CURRENT_TIMESTAMP,
							Trail
							FROM @TablaGrupoTemp
					END
				--Creación de un nuevo vehículo
				ELSE
					BEGIN
					 --Actualizamos nuestra tabla temporal de grupos detalles a insertar
						update @TablaGrupoTemp set VehiculoId = @NuevoID
						
						-- Inserción
						Insert into Vehiculos.GruposDetalles(
							GrupoId,
							VehiculoId,
							Usuario,
							Eliminado,
							FechaCreacion,
							Trail
						)SELECT
							GrupoId,
							VehiculoId,
							Usuario,
							1,
							CURRENT_TIMESTAMP,
							Trail
							FROM @TablaGrupoTemp
					END
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
