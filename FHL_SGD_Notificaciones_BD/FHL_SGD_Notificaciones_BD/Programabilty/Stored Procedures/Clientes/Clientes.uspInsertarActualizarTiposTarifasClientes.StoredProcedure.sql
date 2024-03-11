USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspInsertarActualizarTiposTarifasClientes]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros
-- =============================================
CREATE PROCEDURE [Clientes].[uspInsertarActualizarTiposTarifasClientes]
	--Parametros necesarios para la ejecución correcta
	 @Lista VARCHAR(MAX) = null
AS
BEGIN
	--Variables de control
	DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = null;
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
		Nombre varchar(500),
		IdInterno varchar(20),
		TipoTarifaId bigint ,
		MonedaIdCosto int,
		Costo decimal(18, 2),
		CostoNoArmada numeric(18, 0),
		CostoArmada numeric(18, 0),
		ValorMinimoArmada numeric(18, 0),
		TipoPesoId bigint,
		TipoEmpaqueId bigint,
		TipoVehiculoId bigint,
		PrioridadId bigint,
		ParadaIntermedia varchar(5000),
		Origen varchar(5000),
		Destino varchar(5000),
		PromesaEntrega int,
		DiasEntregaId varchar(5000),
		MonedaIdGastoOperativoPermitido int,
		GastoOperativoPermitido decimal(18, 2),
		MonedaIdCancelacionConManifiesto int,
		CancelacionConManifiesto decimal(18, 2),
		MonedaIdCancelacionConBorrador int,
		CancelacionConBorrador decimal(18, 2),
		MonedaIdCostoParadaIntermedia int,
		CostoParadaIntermedia decimal(18, 2),
		MonedaIdCostoRetorno int,
		CostoRetorno decimal(18, 2),
		TipoCustodia varchar(500),
		Utilidad numeric(18, 0),
		ProveedorId bigint,
		FechaVigenciaInicial datetime,
		FechaVigenciaFinal datetime,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max));
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
			Id
			,Nombre
			,IdInterno
			,TipoTarifaId
			,MonedaIdCosto
			,Costo
			,CostoNoArmada
			,CostoArmada
			,ValorMinimoArmada
			,TipoPesoId
			,TipoEmpaqueId
			,TipoVehiculoId
			,PrioridadId
			,ParadaIntermedia
			,Origen
			,Destino
			,PromesaEntrega
			,DiasEntregaId
			,MonedaIdGastoOperativoPermitido
			,GastoOperativoPermitido
			,MonedaIdCancelacionConManifiesto
			,CancelacionConManifiesto
			,MonedaIdCancelacionConBorrador
			,CancelacionConBorrador
			,MonedaIdCostoParadaIntermedia
			,CostoParadaIntermedia
			,MonedaIdCostoRetorno
			,CostoRetorno
			,TipoCustodia
			,Utilidad
			,ProveedorId
			,FechaVigenciaInicial
			,FechaVigenciaFinal
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail) SELECT * FROM OPENJSON(@Lista)
			WITH(
			Id bigint,
			Nombre varchar(500),
			IdInterno varchar(20),
			TipoTarifaId bigint ,
			MonedaIdCosto int,
			Costo decimal(18, 2),
			CostoNoArmada numeric(18, 0),
			CostoArmada numeric(18, 0),
			ValorMinimoArmada numeric(18, 0),
			TipoPesoId bigint,
			TipoEmpaqueId bigint,
			TipoVehiculoId bigint,
			PrioridadId bigint,
			ParadaIntermedia varchar(5000),
			Origen varchar(5000),
			Destino varchar(5000),
			PromesaEntrega int,
			DiasEntregaId varchar(5000),
			MonedaIdGastoOperativoPermitido int,
			GastoOperativoPermitido decimal(18, 2),
			MonedaIdCancelacionConManifiesto int,
			CancelacionConManifiesto decimal(18, 2),
			MonedaIdCancelacionConBorrador int,
			CancelacionConBorrador decimal(18, 2),
			MonedaIdCostoParadaIntermedia int,
			CostoParadaIntermedia decimal(18, 2),
			MonedaIdCostoRetorno int,
			CostoRetorno decimal(18, 2),
			TipoCustodia varchar(500),
			Utilidad numeric(18, 0),
			ProveedorId bigint,
			FechaVigenciaInicial datetime,
			FechaVigenciaFinal datetime,
			Usuario varchar(150),
			Eliminado bit,
			FechaCreacion datetime,
			Trail varchar(max));

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO Clientes.TiposTarifasClientes(
				Nombre
				,IdInterno
				,TipoTarifaId
				,MonedaIdCosto
				,Costo
				,CostoNoArmada
				,CostoArmada
				,ValorMinimoArmada
				,TipoPesoId
				,TipoEmpaqueId
				,TipoVehiculoId
				,PrioridadId
				,ParadaIntermedia
				,Origen
				,Destino
				,PromesaEntrega
				,DiasEntregaId
				,MonedaIdGastoOperativoPermitido
				,GastoOperativoPermitido
				,MonedaIdCancelacionConManifiesto
				,CancelacionConManifiesto
				,MonedaIdCancelacionConBorrador
				,CancelacionConBorrador
				,MonedaIdCostoParadaIntermedia
				,CostoParadaIntermedia
				,MonedaIdCostoRetorno
				,CostoRetorno
				,TipoCustodia
				,Utilidad
				,ProveedorId
				,FechaVigenciaInicial
				,FechaVigenciaFinal
				,Usuario
				,Eliminado
				,FechaCreacion
				,Trail) SELECT
				Nombre
				,IdInterno
				,TipoTarifaId
				,MonedaIdCosto
				,Costo
				,CostoNoArmada
				,CostoArmada
				,ValorMinimoArmada
				,TipoPesoId
				,TipoEmpaqueId
				,TipoVehiculoId
				,PrioridadId
				,ParadaIntermedia
				,Origen
				,Destino
				,PromesaEntrega
				,DiasEntregaId
				,MonedaIdGastoOperativoPermitido
				,GastoOperativoPermitido
				,MonedaIdCancelacionConManifiesto
				,CancelacionConManifiesto
				,MonedaIdCancelacionConBorrador
				,CancelacionConBorrador
				,MonedaIdCostoParadaIntermedia
				,CostoParadaIntermedia
				,MonedaIdCostoRetorno
				,CostoRetorno
				,TipoCustodia
				,Utilidad
				,ProveedorId
				,FechaVigenciaInicial
				,FechaVigenciaFinal
				,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE Clientes.TiposTarifasClientes
				SET
					Nombre = tmp.Nombre
					,IdInterno = tmp.IdInterno
					,TipoTarifaId = tmp.TipoTarifaId
					,MonedaIdCosto = tmp.MonedaIdCosto
					,Costo = tmp.Costo
					,CostoNoArmada = tmp.CostoNoArmada
					,CostoArmada = tmp.CostoArmada
					,ValorMinimoArmada = tmp.ValorMinimoArmada
					,TipoPesoId = tmp.TipoPesoId
					,TipoEmpaqueId = tmp.TipoEmpaqueId
					,TipoVehiculoId = tmp.TipoVehiculoId
					,PrioridadId = tmp.PrioridadId
					,ParadaIntermedia = tmp.ParadaIntermedia
					,Origen = tmp.Origen
					,Destino = tmp.Destino
					,PromesaEntrega = tmp.PromesaEntrega
					,DiasEntregaId = tmp.DiasEntregaId
					,MonedaIdGastoOperativoPermitido = tmp.MonedaIdGastoOperativoPermitido
					,GastoOperativoPermitido = tmp.GastoOperativoPermitido
					,MonedaIdCancelacionConManifiesto = tmp.MonedaIdCancelacionConManifiesto
					,CancelacionConManifiesto = tmp.CancelacionConManifiesto
					,MonedaIdCancelacionConBorrador = tmp.MonedaIdCancelacionConBorrador
					,CancelacionConBorrador = tmp.CancelacionConBorrador
					,MonedaIdCostoParadaIntermedia = tmp.MonedaIdCostoParadaIntermedia
					,CostoParadaIntermedia = tmp.CostoParadaIntermedia
					,MonedaIdCostoRetorno = tmp.MonedaIdCostoRetorno
					,CostoRetorno = tmp.CostoRetorno
					,TipoCustodia = tmp.TipoCustodia
					,Utilidad = tmp.Utilidad
					,ProveedorId = tmp.ProveedorId
					,FechaVigenciaInicial = tmp.FechaVigenciaInicial
					,FechaVigenciaFinal = tmp.FechaVigenciaFinal
					,Usuario = tmp.Usuario
					,Eliminado = 1
					,Trail = tmp.Trail					
					FROM @Tablatemp tmp WHERE Clientes.TiposTarifasClientes.Id = tmp.Id;

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
