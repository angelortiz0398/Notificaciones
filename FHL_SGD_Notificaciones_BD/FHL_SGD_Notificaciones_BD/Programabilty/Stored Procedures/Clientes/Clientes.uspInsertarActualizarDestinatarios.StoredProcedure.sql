USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspInsertarActualizarDestinatarios]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Clientes].[uspInsertarActualizarDestinatarios]
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
		RazonSocial varchar(500),
		RFC varchar(14),
		AxaptaId varchar(50),
		Referencia varchar(500),
		Calle varchar(500),
		NumeroExterior varchar(20),
		NumeroInterior varchar(20),
		Colonia varchar(500),
		Localidad varchar(500),
		Municipio varchar(500),
		Estado varchar(500),
		Pais varchar(150),
		CodigoPostal int,
		Coordenadas varchar(300),
		RecepcionCita bit,
		VentanaAtencion varchar(1500),
		RestriccionCirculacion varchar(500),
		HabilidadVehiculo varchar(2000),
		DocumentoVehiculo varchar(2000),
		HabilidadOperador varchar(2000),
		DocumentoOperador varchar(2000),
		HabilidadAuxiliar varchar(2000),
		DocumentoAuxiliar varchar(2000),
		EvidenciaSalida varchar(2000),
		EvidenciaLlegada varchar(2000),
		Sellos bit,
		Checklist varchar(2000),
		Contacto varchar(2000),
		Geolocalizacion varchar(2000),
		TiempoParado int,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id
			,ClienteId
			,RazonSocial
			,RFC
			,AxaptaId
			,Referencia
			,Calle
			,NumeroExterior
			,NumeroInterior
			,Colonia
			,Localidad
			,Municipio
			,Estado
			,Pais
			,CodigoPostal
			,Coordenadas
			,RecepcionCita
			,VentanaAtencion
			,RestriccionCirculacion
			,HabilidadVehiculo
			,DocumentoVehiculo
			,HabilidadOperador
			,DocumentoOperador
			,HabilidadAuxiliar
			,DocumentoAuxiliar
			,EvidenciaSalida
			,EvidenciaLlegada
			,Sellos
			,Checklist
			,Contacto
			,Geolocalizacion
			,TiempoParado
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			ClienteId bigint,
			RazonSocial varchar(500),
			RFC varchar(14),
			AxaptaId varchar(50),
			Referencia varchar(500),
			Calle varchar(500),
			NumeroExterior varchar(20),
			NumeroInterior varchar(20),
			Colonia varchar(500),
			Localidad varchar(500),
			Municipio varchar(500),
			Estado varchar(500),
			Pais varchar(150),
			CodigoPostal int,
			Coordenadas varchar(300),
			RecepcionCita bit,
			VentanaAtencion varchar(1500),
			RestriccionCirculacion varchar(500),
			HabilidadVehiculo varchar(2000),
			DocumentoVehiculo varchar(2000),
			HabilidadOperador varchar(2000),
			DocumentoOperador varchar(2000),
			HabilidadAuxiliar varchar(2000),
			DocumentoAuxiliar varchar(2000),
			EvidenciaSalida varchar(2000),
			EvidenciaLlegada varchar(2000),
			Sellos bit,
			Checklist varchar(2000),
			Contacto varchar(2000),
			Geolocalizacion varchar(2000),
			TiempoParado int,
			Usuario varchar(150),
			Eliminado bit,
			FechaCreacion datetime,
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Clientes].[Destinatarios](
				ClienteId
				,RazonSocial
				,RFC
				,AxaptaId
				,Referencia
				,Calle
				,NumeroExterior
				,NumeroInterior
				,Colonia
				,Localidad
				,Municipio
				,Estado
				,Pais
				,CodigoPostal
				,Coordenadas
				,RecepcionCita
				,VentanaAtencion
				,RestriccionCirculacion
				,HabilidadVehiculo
				,DocumentoVehiculo
				,HabilidadOperador
				,DocumentoOperador
				,HabilidadAuxiliar
				,DocumentoAuxiliar
				,EvidenciaSalida
				,EvidenciaLlegada
				,Sellos
				,Checklist
				,Contacto
				,Geolocalizacion
				,TiempoParado
				,Usuario
				,Eliminado
				,FechaCreacion
				,Trail) SELECT
				ClienteId
				,RazonSocial
				,RFC
				,AxaptaId
				,Referencia
				,Calle
				,NumeroExterior
				,NumeroInterior
				,Colonia
				,Localidad
				,Municipio
				,Estado
				,Pais
				,CodigoPostal
				,Coordenadas
				,RecepcionCita
				,VentanaAtencion
				,RestriccionCirculacion
				,HabilidadVehiculo
				,DocumentoVehiculo
				,HabilidadOperador
				,DocumentoOperador
				,HabilidadAuxiliar
				,DocumentoAuxiliar
				,EvidenciaSalida
				,EvidenciaLlegada
				,Sellos
				,Checklist
				,Contacto
				,Geolocalizacion
				,TiempoParado
				,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Clientes].[Destinatarios]
				SET
					ClienteId = tmp.ClienteId
					,RazonSocial = tmp.RazonSocial
					,RFC = tmp.RFC
					,AxaptaId = tmp.AxaptaId
					,Referencia = tmp.Referencia
					,Calle = tmp.Calle
					,NumeroExterior = tmp.NumeroExterior
					,NumeroInterior = tmp.NumeroInterior
					,Colonia = tmp.Colonia
					,Localidad = tmp.Localidad
					,Municipio = tmp.Municipio
					,Estado = tmp.Estado
					,Pais = tmp.Pais
					,CodigoPostal = tmp.CodigoPostal
					,Coordenadas = tmp.Coordenadas
					,RecepcionCita = tmp.RecepcionCita
					,VentanaAtencion = tmp.VentanaAtencion
					,RestriccionCirculacion = tmp.RestriccionCirculacion
					,HabilidadVehiculo = tmp.HabilidadVehiculo
					,DocumentoVehiculo = tmp.DocumentoVehiculo
					,HabilidadOperador = tmp.HabilidadOperador
					,DocumentoOperador = tmp.DocumentoOperador
					,HabilidadAuxiliar = tmp.HabilidadAuxiliar
					,DocumentoAuxiliar = tmp.DocumentoAuxiliar
					,EvidenciaSalida = tmp.EvidenciaSalida
					,EvidenciaLlegada = tmp.EvidenciaLlegada
					,Sellos = tmp.Sellos
					,Checklist = tmp.Checklist
					,Contacto = tmp.Contacto
					,Geolocalizacion = tmp.Geolocalizacion
					,TiempoParado = tmp.TiempoParado
					,Usuario = tmp.Usuario 
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE [Clientes].[Destinatarios].[Id] = tmp.[Id];

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
			SET @Mensaje = 'Hubo un error en los registros recibidos y los registros guardados';
		END

	--Devuelve el resultado de la inserción o actualización de los registros enviados
	SALIDA:
		SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END
GO
