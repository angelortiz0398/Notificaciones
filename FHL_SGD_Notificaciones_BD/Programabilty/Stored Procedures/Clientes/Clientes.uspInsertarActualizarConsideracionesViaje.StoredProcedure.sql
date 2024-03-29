USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspInsertarActualizarConsideracionesViaje]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Clientes].[uspInsertarActualizarConsideracionesViaje]
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
		ClienteId bigint,
		HabilidadVehiculo varchar(2000),
		DocumentoVehiculo varchar(2000),
		HabilidadDeColaborador varchar(2000),
		DocumentoOperador varchar(2000),
		HabilidadAuxiliar varchar(2000),
		DocumentoAuxiliar varchar(2000),
		EvidenciaCarga varchar(2000),
		EvidenciaDescarga varchar(2000),
		Checklist varchar(2000),
		Contacto varchar(2000),
		Geolocalizacion varchar(2000),
		TiempoSalidaPrevio int,
		PresenciaOperador int,
		HorasEmbarque int,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id
			,ClienteId
			,HabilidadVehiculo
			,DocumentoVehiculo
			,HabilidadDeColaborador
			,DocumentoOperador
			,HabilidadAuxiliar
			,DocumentoAuxiliar
			,EvidenciaCarga
			,EvidenciaDescarga
			,Checklist
			,Contacto
			,Geolocalizacion
			,TiempoSalidaPrevio
			,PresenciaOperador
			,HorasEmbarque
			,Usuario
			,Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			ClienteId bigint,
			HabilidadVehiculo varchar(2000),
			DocumentoVehiculo varchar(2000),
			HabilidadDeColaborador varchar(2000),
			DocumentoOperador varchar(2000),
			HabilidadAuxiliar varchar(2000),
			DocumentoAuxiliar varchar(2000),
			EvidenciaCarga varchar(2000),
			EvidenciaDescarga varchar(2000),
			Checklist varchar(2000),
			Contacto varchar(2000),
			Geolocalizacion varchar(2000),
			TiempoSalidaPrevio int,
			PresenciaOperador int,
			HorasEmbarque int,
			Usuario varchar(150),
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Clientes].[ConsideracionesViajes](
				ClienteId
				,HabilidadVehiculo
				,DocumentoVehiculo
				,HabilidadDeColaborador
				,DocumentoOperador
				,HabilidadAuxiliar
				,DocumentoAuxiliar
				,EvidenciaCarga
				,EvidenciaDescarga
				,Checklist
				,Contacto
				,Geolocalizacion
				,TiempoSalidaPrevio
				,PresenciaOperador
				,HorasEmbarque
				,Usuario
				,Eliminado
				,FechaCreacion
				,Trail) SELECT
				ClienteId
				,HabilidadVehiculo
				,DocumentoVehiculo
				,HabilidadDeColaborador
				,DocumentoOperador
				,HabilidadAuxiliar
				,DocumentoAuxiliar
				,EvidenciaCarga
				,EvidenciaDescarga
				,Checklist
				,Contacto
				,Geolocalizacion
				,TiempoSalidaPrevio
				,PresenciaOperador
				,HorasEmbarque
				,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Clientes].[ConsideracionesViajes]
				SET
					ClienteId = tmp.ClienteId
					,HabilidadVehiculo = tmp.HabilidadVehiculo
					,DocumentoVehiculo = tmp.DocumentoVehiculo
					,HabilidadDeColaborador = tmp.HabilidadDeColaborador
					,DocumentoOperador = tmp.DocumentoOperador
					,HabilidadAuxiliar = tmp.HabilidadAuxiliar
					,DocumentoAuxiliar = tmp.DocumentoAuxiliar
					,EvidenciaCarga = tmp.EvidenciaCarga
					,EvidenciaDescarga = tmp.EvidenciaDescarga
					,Checklist = tmp.Checklist
					,Contacto = tmp.Contacto
					,Geolocalizacion = tmp.Geolocalizacion
					,TiempoSalidaPrevio = tmp.TiempoSalidaPrevio
					,PresenciaOperador = tmp.PresenciaOperador
					,HorasEmbarque = tmp.HorasEmbarque
					,Usuario = tmp.Usuario
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE [Clientes].[ConsideracionesViajes].[Id] = tmp.[Id];

			-- 7. Almacena la cantidad de registros actualizados
			SET @RegistrosActualizados = @@ROWCOUNT;
		COMMIT;
		END TRY
		BEGIN CATCH
			SET @Resultado = -1;
			SET @Mensaje = 'Hubo un error al guardar los registros.';
			ROLLBACK;
			GOTO SALIDA;
		END CATCH


		-- 8. Se validara que se insertaron o actualizaron la misma cantidad de tickets asignados que se enviaron
		IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM @Tablatemp))
		BEGIN
			SET @Resultado = 0;
			SET @Mensaje = 'Registros guardados de forma correcta.';
		END
		ELSE
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json.';
		END

	--Devuelve el resultado de la inserción o actualización de los registros enviados
	SALIDA:
		SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
