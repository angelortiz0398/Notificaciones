USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspInsertarActualizarColaboradores]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Angel Ortiz
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Operadores].[uspInsertarActualizarColaboradores]
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
				Id Bigint  not null,
				Nombre varchar(500) NULL,
				RFC varchar(13) NULL,
				Identificacion varchar(20) NULL,
				TipoPerfilesId bigint NULL,
				CentroDistribucionesId bigint NULL,
				NSS varchar(30) NULL,
				CorreoElectronico varchar(150) NULL,
				Telefono varchar(15) NULL,
				IMEI varchar(20) NULL,
				Habilidades varchar(2000) NULL,
				TipoVehiculo varchar(2000) NULL,
				Estado bit NULL,
				Comentarios varchar(1000) NULL,
				UltimoAcceso datetime NULL,
				Usuario varchar(150) NULL,
				Eliminado bit NULL,
				FechaCreacion datetime NULL,
				Trail varchar(max) NULL
			);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
		       Id
			  ,Nombre
			  ,RFC
			  ,Identificacion
			  ,TipoPerfilesId
			  ,CentroDistribucionesId
			  ,NSS
			  ,CorreoElectronico
			  ,Telefono
			  ,IMEI
			  ,Habilidades
			  ,TipoVehiculo
			  ,Estado
			  ,Comentarios
			  ,UltimoAcceso
			  ,Usuario
			  ,Eliminado
			  ,FechaCreacion
			  ,Trail
			)	 
			SELECT * FROM OPENJSON(@Lista)
			WITH(
			    Id bigint,
				Nombre varchar(500),
				Rfc varchar(13),
				Identificacion varchar(20),
				TipoPerfilesId bigint,
				CentroDistribucionesId bigint,
				Nss varchar(30),
				CorreoElectronico varchar(150),
				Telefono varchar(15),
				Imei varchar(20),
				Habilidades varchar(2000),
				TipoVehiculo varchar(2000),
				Estado bit,
				Comentarios varchar(1000),
				UltimoAcceso datetime,
				Usuario varchar(150),
				Eliminado bit,
				FechaCreacion datetime,
				Trail varchar(max)
				);

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Operadores].[Colaboradores](
			   Nombre
			  ,RFC
			  ,Identificacion
			  ,TipoPerfilesId
			  ,CentroDistribucionesId
			  ,NSS
			  ,CorreoElectronico
			  ,Telefono
			  ,IMEI
			  ,Habilidades
			  ,TipoVehiculo
			  ,Estado
			  ,Comentarios
			  ,UltimoAcceso
			  ,Usuario
			  ,Eliminado
			  ,FechaCreacion
			  ,Trail
			) 
			SELECT
			   temp.Nombre
			  ,temp.RFC
			  ,temp.Identificacion
			  ,temp.TipoPerfilesId
			  ,temp.CentroDistribucionesId
			  ,temp.NSS
			  ,temp.CorreoElectronico
			  ,temp.Telefono
			  ,temp.IMEI
			  ,temp.Habilidades
			  ,temp.TipoVehiculo
			  ,temp.Estado
			  ,temp.Comentarios
			  ,temp.UltimoAcceso
			  ,temp.Usuario
			  ,1
			  ,CURRENT_TIMESTAMP
			  ,temp.Trail
			 -- FROM @Tablatemp temp WHERE not EXISTS(SELECT 1 FROM Operadores.Colaboradores WHERE Colaboradores.Nombre = temp.Nombre);
			 FROM @Tablatemp temp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;

			-- 6. Instrucción para actualizar registros
			UPDATE [Operadores].[Colaboradores]
				      SET Nombre = tmp.Nombre
					  ,RFC = tmp.RFC
					  ,TipoPerfilesId = tmp.TipoPerfilesId
					  ,CentroDistribucionesId = tmp.CentroDistribucionesId
					  ,NSS = tmp.NSS
					  ,IMEI = tmp.IMEI
					  ,Identificacion = tmp.Identificacion
					  ,Habilidades = tmp.Habilidades
					  ,TipoVehiculo = tmp.TipoVehiculo
					  ,Comentarios = tmp.Comentarios
					  ,CorreoElectronico = tmp.CorreoElectronico
					  ,Telefono = tmp.Telefono
					  ,Usuario = tmp.Usuario
					  ,Trail = tmp.Trail
					FROM @Tablatemp tmp WHERE [Operadores].[Colaboradores].[Id] = tmp.[Id];

			-- 7. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;
		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error para guardar los registros';
			ROLLBACK;
			GOTO SALIDA;
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
			SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json';
		END

	--Devuelve el resultado de la inserción o actualización de los registros enviados
	SALIDA:
		SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
