USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspInsertarActualizarDespachos] 
	@Json varchar(MAX) = NULL   
AS
BEGIN
    -- Variables de control
    DECLARE @Resultado  INT = 0;
	DECLARE @Id  BIGINT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'El despacho se guardó correctamente.';
	DECLARE @CurrentFolio BIGINT = 0; 
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT;
    -- Validación de parámetros
    IF @Json IS NULL 
        BEGIN
            SET @Resultado = -1;
			SET @Id = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para insertar o actualizar el despacho';
            GOTO SALIDA;
        END
	ELSE IF ISJSON(@Json) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				SET @Id = -2;
				SET @Mensaje = 'La información del despacho no está en formato JSON esperado';
				GOTO SALIDA;				
			END;

-- Inserta o actualiza el Despacho
	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		Id bigint NULL,
		FolioDespacho varchar(20) NULL,
		Borrador bit NULL,
		Origen varchar(500) NULL,
		Destino varchar(500) NULL,
		VehiculoId bigint NULL,
		VehiculoTercero varchar(3000) NULL,
		RemolqueId bigint NULL,
		OperadorId bigint NULL,
		Custodia bit NULL,
		Auxiliares varchar(max) NULL,
		Peligroso bit NULL,
		RutaId bigint NULL,
		ServiciosAdicionales varchar(max) NULL,
		AndenId bigint NULL,
		EstatusId bigint NULL,
		Usuario varchar(150) NULL,
		Trail varchar(max) NULL,
		OcupacionEfectiva varchar(20) NULL,
		TiempoEntrega varchar(30) NULL,
		RegistroNuevo BIT DEFAULT 1
	)
	-- Se inserta en la tabla temporal a partir del json 
	INSERT INTO #TablaTmp(
		Id
		,FolioDespacho
		,Borrador
		,Origen
		,Destino
		,VehiculoId
		,VehiculoTercero
		,RemolqueId
		,OperadorId
		,Custodia
		,Auxiliares
		,Peligroso
		,RutaId
		,ServiciosAdicionales
		,AndenId
		,EstatusId
		,Usuario
		,Trail
		,OcupacionEfectiva
		,TiempoEntrega)
	SELECT * FROM OPENJSON (@Json)
	WITH
	(
		Id bigint,
		FolioDespacho varchar(20),
		Borrador bit,
		Origen varchar(500),
		Destino varchar(500),
		VehiculoId bigint,
		VehiculoTercero varchar(3000),
		RemolqueId bigint,
		OperadorId bigint,
		Custodia bit,
		Auxiliares varchar(max),
		Peligroso bit,
		RutaId bigint,
		ServiciosAdicionales varchar(max),
		AndenId bigint,
		EstatusId bigint,
		Usuario varchar(150),
		Trail varchar(max),
		OcupacionEfectiva varchar(20),
		TiempoEntrega varchar(30)
	)
	-- Se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
		Update #TablaTmp set RegistroNuevo = 0
		FROM #TablaTmp
		JOIN Despachos.Despachos on #TablaTmp.Id = Despachos.Id

    -- Inserta la información de aquellos que encuentra que son Despachos nuevos y complementa con campos con información predefinida
	BEGIN TRANSACTION;
	BEGIN TRY
	INSERT INTO Despachos.Despachos(
		FolioDespacho
		,Borrador
		,Origen
		,Destino
		,VehiculoId
		,VehiculoTercero
		,RemolqueId
		,OperadorId
		,Custodia
		,Auxiliares
		,Peligroso
		,RutaId
		,ServiciosAdicionales
		,AndenId
		,EstatusId
		,Usuario
		,Eliminado
		,FechaCreacion
		,Trail
		,OcupacionEfectiva
		,TiempoEntrega)
	SELECT
		tmp.FolioDespacho
		,tmp.Borrador
		,tmp.Origen
		,tmp.Destino
		,tmp.VehiculoId
		,tmp.VehiculoTercero
		,tmp.RemolqueId
		,tmp.OperadorId
		,tmp.Custodia
		,tmp.Auxiliares
		,tmp.Peligroso
		,tmp.RutaId
		,tmp.ServiciosAdicionales
		,tmp.AndenId
		,tmp.EstatusId
		,tmp.Usuario
		,1
		,CURRENT_TIMESTAMP
		,tmp.Trail
		,tmp.OcupacionEfectiva
		,tmp.TiempoEntrega
	FROM #TablaTmp tmp
            WHERE RegistroNuevo = 1;
	-- Almacena la cantidad de registros insertados
	SET @RegistrosInsertados = @@ROWCOUNT;
	SET @Resultado = SCOPE_IDENTITY();
	SET @Id = SCOPE_IDENTITY();

	-- Seccion en donde se actualizan los registros que ya existian pero solo con la informacion que enviamos
	UPDATE Despachos.Despachos
	SET FolioDespacho = tmp.FolioDespacho
			,Borrador = tmp.Borrador
			,Origen = tmp.Origen
			,Destino = tmp.Destino
			,VehiculoId = tmp.VehiculoId
			,VehiculoTercero = tmp.VehiculoTercero
			,RemolqueId = tmp.RemolqueId
			,OperadorId = tmp.OperadorId
			,Custodia = tmp.Custodia
			,Auxiliares = tmp.Auxiliares
			,Peligroso = tmp.Peligroso
			,RutaId = tmp.RutaId
			,ServiciosAdicionales = tmp.ServiciosAdicionales
			,AndenId = tmp.AndenId
			,EstatusId = tmp.EstatusId
			,Usuario = tmp.Usuario
			,Trail = tmp.Trail
			,OcupacionEfectiva = tmp.OcupacionEfectiva
			,TiempoEntrega = tmp.TiempoEntrega
	FROM #TablaTmp tmp
	WHERE Despachos.Despachos.[Id] = tmp.[Id]
		AND tmp.RegistroNuevo = 0;

	-- Almacena la cantidad de registros actualizados
	SET @RegistrosActualizados = @@ROWCOUNT;
	-- Este resultado solo afecta si se edita solo un registro y es para recuperar el Id
	IF (SELECT TOP 1 Id FROM #TablaTmp) > 0
	BEGIN 
		SET @Resultado = (SELECT TOP 1 Id FROM #TablaTmp);
		SET @Id = (SELECT TOP 1 Id FROM #TablaTmp);
	END

	COMMIT;
	END TRY
	BEGIN CATCH
		SET @Resultado = -1;
		SET @Mensaje = 'Hubo un error para guardar los registros';
		ROLLBACK;
		GOTO SALIDA;
	END CATCH
	-- Se validara que se insertaron o actualizaron la misma cantidad de Despachos que se enviaron
	IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM #TablaTmp))
	BEGIN
		SET @Mensaje = 'Los Despachos se guardaron correctamente.';
	END
	ELSE
	BEGIN
		SET @Resultado = -1;
		SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json';
	END

	-- Elimina la tabla temporal
	DROP TABLE #TablaTmp;

    -- Devuelve el resultado de la inserción o actualización del Despacho
    SALIDA:
        SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida, @Id AS Id
END
GO
