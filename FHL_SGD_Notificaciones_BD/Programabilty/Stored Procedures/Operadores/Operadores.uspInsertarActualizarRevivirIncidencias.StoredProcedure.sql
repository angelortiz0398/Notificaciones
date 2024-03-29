USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspInsertarActualizarRevivirIncidencias]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros con validacion de repetidos
-- =============================================
CREATE PROCEDURE [Operadores].[uspInsertarActualizarRevivirIncidencias]
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
	--  0 : Revivir-> Registro creado corrrectamente
	--  1 : Creado-> Registro creado corrrectamente
	--  2 : Actualizar-> Registro actualizado correctamente
	print @Json
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
		Id bigint NOT NULL,
		Nombre varchar(250) NULL,
		Puntos int NULL,
		Usuario varchar(150) NULL,
		Eliminado bit NULL,
		FechaCreacion datetime NULL,
		Trail varchar(max) NULL
		);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
	INSERT INTO @Tablatemp(
					Id
					,Nombre
					,Puntos
					,Usuario
					,Eliminado
					,FechaCreacion
					,Trail
							)
	   SELECT * FROM OPENJSON(@Json)
			WITH(
			Id bigint  ,
			Nombre varchar(250) ,
			Puntos int ,
			Usuario varchar(150) ,
			Eliminado bit ,
			FechaCreacion datetime ,
			Trail varchar(max)
					);

	--4. Error al CREAR -> Validaremos que no sea un registro existente
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Operadores].[Incidencias] Incidencia
				ON LOWER(LTRIM(RTRIM(temp.Nombre))) = LOWER(LTRIM(RTRIM(Incidencia.Nombre)))
				WHERE temp.Id = 0 AND Incidencia.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -2;
				SET @Mensaje = 'Actualmente existe un registro con ese "Nombre"';
				GOTO Salida;
			END;

	--5. Error al ACTUALIZAR -> Validaremos que no exista un registro con ese nombre
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Operadores].[Incidencias] Incidencia
				ON LOWER(LTRIM(RTRIM(temp.Nombre))) = LOWER(LTRIM(RTRIM(Incidencia.Nombre))) 
				WHERE temp.Id != Incidencia.Id AND Incidencia.Eliminado = 1)
			BEGIN
				--Modificamos los mensajes y el resultado
				SET @Resultado = -1;
				SET @Mensaje = 'Actualmente existe un registro con ese "Nombre"';
				GOTO Salida;
			END;
		
	--6. REVIVIR -> Se le asignara el Id de un registro eliminado si ya existia el Nombre en un registro anterior
		IF EXISTS(SELECT 1 FROM @Tablatemp temp 
				INNER JOIN [Operadores].[Incidencias] Incidencia
				ON LOWER(LTRIM(RTRIM(temp.Nombre))) = LOWER(LTRIM(RTRIM(Incidencia.Nombre))) 
				WHERE temp.Id = 0 AND Incidencia.Eliminado = 0)
			BEGIN
				--Le modificamos el Id al registro recibido
				UPDATE temp SET temp.Id = Incidencia.Id FROM @Tablatemp temp
				INNER JOIN [Operadores].[Incidencias] Incidencia
				ON LOWER(LTRIM(RTRIM(temp.Nombre))) = LOWER(LTRIM(RTRIM(Incidencia.Nombre))) 
				WHERE temp.Id = 0 AND Incidencia.Eliminado = 0;

				--Modificamos los mensajes y el resultado ademas de encender la bandera de revivido
				SET @Revivido = 1;
				SET @Resultado = 0;
				SET @Mensaje = 'Registro reactivado correctamente';
			END;



		-- 7. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Operadores].[Incidencias]
			(
				Nombre
				,Puntos
				,Usuario
				,Eliminado
				,FechaCreacion
				,Trail
			)
				 SELECT
					Nombre
					,Puntos
					,Usuario
					,1
					,CURRENT_TIMESTAMP
					,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 8. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 9. Instrucción para actualizar registros
			UPDATE [Operadores].[Incidencias]
				SET
					Nombre = tmp.Nombre
					,Puntos = tmp.Puntos
					,Usuario = tmp.Usuario
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE [Operadores].[Incidencias].[Id] = tmp.[Id];

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
