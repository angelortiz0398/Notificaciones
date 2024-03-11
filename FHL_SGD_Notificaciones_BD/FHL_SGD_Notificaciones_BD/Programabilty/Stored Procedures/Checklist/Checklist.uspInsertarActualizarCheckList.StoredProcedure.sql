USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Checklist].[uspInsertarActualizarCheckList]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Checklist].[uspInsertarActualizarCheckList]
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
		PonderacionMaxima int,
		FechaVencimiento datetime,
		CorreosNotificacion varchar(max),
		QuienEjecuta varchar(150),
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id,
			Nombre,
			PonderacionMaxima,
			FechaVencimiento,
			CorreosNotificacion,
			QuienEjecuta,
			Usuario,
			Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			Nombre varchar(200),
			PonderacionMaxima int,
			FechaVencimiento datetime,
			CorreosNotificacion varchar(max),
			QuienEjecuta varchar(150),
			Usuario varchar(150),			
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Checklist].[CheckList](
				Nombre,
				PonderacionMaxima,
				FechaVencimiento,
				CorreosNotificacion,
				QuienEjecuta,
				Usuario,
				Eliminado,
				FechaCreacion,
				Trail) SELECT
				Nombre,
				PonderacionMaxima,
				FechaVencimiento,
				CorreosNotificacion,
				QuienEjecuta,
				Usuario,
				1,
				CURRENT_TIMESTAMP,
				Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Checklist].[CheckList]
				SET
					Nombre = tmp.Nombre,
					PonderacionMaxima = tmp.PonderacionMaxima,
					FechaVencimiento = tmp.FechaVencimiento,
					CorreosNotificacion = tmp.CorreosNotificacion,
					QuienEjecuta = tmp.QuienEjecuta,
					Usuario = tmp.Usuario,
					Eliminado = 1,
					Trail = tmp.Trail 
					FROM @Tablatemp tmp WHERE [Checklist].[CheckList].[Id] = tmp.[Id];

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
