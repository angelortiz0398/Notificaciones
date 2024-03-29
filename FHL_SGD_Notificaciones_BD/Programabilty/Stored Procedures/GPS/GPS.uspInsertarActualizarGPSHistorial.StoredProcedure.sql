USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GPS].[uspInsertarActualizarGPSHistorial]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [GPS].[uspInsertarActualizarGPSHistorial]
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
		--Id bigint,
		--VehiculoId bigint,
		--Imei bigint,
		--Nombre varchar(50),
		--Licencia varchar(50),
		--Latitud numeric(18, 6),
		--Longitud numeric(18, 6),
		--Curso int,
		--Velocidad numeric(18, 2),
		--Odometro numeric(18, 2),
		--PuertaCabina varchar(50),
		--PuertaCarga varchar(50),
		--Bateria numeric(18, 2),
		--UltimaPosicion datetime,
		--Usuario varchar(150),
		--Eliminado bit,
		--FechaCreacion datetime,
		--Trail varchar(max)
		[Id] [bigint] NOT NULL,
		[VehiculoId] [bigint] NOT NULL,
		[Imei] [bigint] NULL,
		[Nombre] [varchar](50) NULL,
		[Licencia] [varchar](50) NULL,
		[Latitud] [numeric](18, 6) NULL,
		[Longitud] [numeric](18, 6) NULL,
		[Curso] [int] NULL,
		[Velocidad] [numeric](18, 2) NULL,
		[Odometro] [numeric](18, 2) NULL,
		[PuertaCabina] [varchar](50) NULL,
		[PuertaCarga] [varchar](50) NULL,
		[Bateria] [numeric](18, 2) NULL,
		[UltimaPosicion] [datetime] NULL,
		[Usuario] [varchar](150) NULL,
		[Eliminado] [bit] NULL,
		[FechaCreacion] [datetime] NULL,
		[Trail] [varchar](max) NULL
		);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id
		  ,VehiculoId
		  ,Imei
		  ,Nombre
		  ,Licencia
		  ,Latitud
		  ,Longitud
		  ,Curso
		  ,Velocidad
		  ,Odometro
		  ,PuertaCabina
		  ,PuertaCarga
		  ,Bateria
		  ,UltimaPosicion
		  ,Usuario
		  ,Eliminado
		  ,FechaCreacion
		  ,Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			VehiculoId bigint,
			Imei bigint,
			Nombre varchar(50),
			Licencia varchar(50),
			Latitud numeric(18, 6),
			Longitud numeric(18, 6),
			Curso int,
			Velocidad numeric(18, 2),
			Odometro numeric(18, 2),
			PuertaCabina varchar(50),
			PuertaCarga varchar(50),
			Bateria numeric(18, 2),
			UltimaPosicion datetime,
			Usuario varchar(150),
			Eliminado bit,
			FechaCreacion datetime,
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
		-- Verificar la existencia de los vehículos en la tabla Vehiculos.Vehiculos
		IF EXISTS (SELECT 1  FROM @Tablatemp AS tmp WHERE NOT EXISTS ( SELECT 1 FROM Vehiculos.Vehiculos AS vehiculos WHERE vehiculos.Id = tmp.VehiculoId))
		BEGIN
        SET @Resultado = -1;
		-- Código de error para vehículo inexistente
        SET @Mensaje = 'Al menos uno de los vehículos especificados no existe.';
        GOTO SALIDA;
		END
			INSERT INTO [GPS].[GPSHistorial](
				VehiculoId
				,Imei
				,Nombre
				,Licencia
				,Latitud
				,Longitud
				,Curso
				,Velocidad
				,Odometro
				,PuertaCabina
				,PuertaCarga
				,Bateria
				,UltimaPosicion
				,Usuario
				,Eliminado
				,FechaCreacion
				,Trail) SELECT
				VehiculoId
				,Imei
				,Nombre
				,Licencia
				,Latitud
				,Longitud
				,Curso
				,Velocidad
				,Odometro
				,PuertaCabina
				,PuertaCarga
				,Bateria
				,UltimaPosicion
				,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp tmp WHERE Id = 0 and EXISTS(SELECT 1 FROM Vehiculos.Vehiculos  vehiculos where tmp.VehiculoId = vehiculos.Id and vehiculos.Eliminado = 1);

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [GPS].[GPSHistorial]
				SET
					VehiculoId = tmp.VehiculoId
					,Imei = tmp.Imei
					,Nombre = tmp.Nombre
					,Licencia = tmp.Licencia
					,Latitud = tmp.Latitud
					,Longitud = tmp.Longitud
					,Curso = tmp.Curso
					,Velocidad = tmp.Velocidad
					,Odometro = tmp.Odometro
					,PuertaCabina = tmp.PuertaCabina
					,PuertaCarga = tmp.PuertaCarga
					,Bateria = tmp.Bateria
					,UltimaPosicion = tmp.UltimaPosicion
					,Usuario = tmp.Usuario
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE [GPS].[GPSHistorial].[Id] = tmp.[Id] and EXISTS(SELECT 1 FROM Vehiculos.Vehiculos  vehiculos where tmp.VehiculoId = vehiculos.Id and vehiculos.Eliminado = 1);

			-- 7. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;
		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error para guardar los registros';
			ROLLBACK;
		END CATCH


		-- 8. Se validara que se insertaron o actualizaron la misma cantidad de tickets asignados que se enviaron
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
