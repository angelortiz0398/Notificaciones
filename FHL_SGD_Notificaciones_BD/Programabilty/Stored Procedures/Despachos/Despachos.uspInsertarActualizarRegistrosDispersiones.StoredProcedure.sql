USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarRegistrosDispersiones]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros de RegistrosDispersiones
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarActualizarRegistrosDispersiones]
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
	Id bigint NOT NULL,
	DespachoId bigint NOT NULL,
	ColaboradorId bigint NOT NULL,
	MonedaIdMonto int NOT NULL,
	Monto numeric(18, 2) NULL,
	TipoGastoId bigint NULL,
	MetodoId int NULL,
	GastoOperativoId int NULL,
	ColaboradorAutorizadoId bigint NULL,
	Usuario varchar(150) NULL,
	Eliminado bit NULL,
	FechaCreacion datetime NULL,
	Trail varchar(max) NULL
			);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
	   Id
      ,DespachoId
      ,ColaboradorId
      ,MonedaIdMonto
      ,Monto
      ,TipoGastoId
      ,MetodoId
      ,GastoOperativoId
      ,ColaboradorAutorizadoId
      ,Usuario
      ,Eliminado
      ,FechaCreacion
      ,Trail
			)	 
			SELECT * FROM OPENJSON(@Lista)
			WITH(
	Id bigint ,
	DespachoId bigint ,
	ColaboradorId bigint ,
	MonedaIdMonto int ,
	Monto numeric(18, 2) ,
	TipoGastoId bigint ,
	MetodoId int ,
	GastoOperativoId int ,
	ColaboradorAutorizadoId bigint ,
	Usuario varchar(150) ,
	Eliminado bit ,
	FechaCreacion datetime ,
	Trail varchar(max) 
				);

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Despachos].[RegistrosDispersiones](
			 
       DespachoId
      ,ColaboradorId
      ,MonedaIdMonto
      ,Monto
      ,TipoGastoId
      ,MetodoId
      ,GastoOperativoId
      ,ColaboradorAutorizadoId
      ,Usuario
      ,Eliminado
      ,FechaCreacion
      ,Trail
			) 
			SELECT
		   	  DespachoId
             ,ColaboradorId
             ,MonedaIdMonto
             ,Monto
             ,TipoGastoId
             ,MetodoId
             ,GastoOperativoId
             ,ColaboradorAutorizadoId
             ,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Despachos].[RegistrosDispersiones]
			   SET DespachoId = tmp.DespachoId
			   	   ,ColaboradorId = tmp.ColaboradorId
			   	   ,MonedaIdMonto = tmp.MonedaIdMonto
			   	   ,Monto = tmp.Monto
			   	   ,TipoGastoId = tmp.TipoGastoId
			   	   ,MetodoId = tmp.MetodoId
			   	   ,GastoOperativoId = tmp.GastoOperativoId
			   	   ,ColaboradorAutorizadoId = tmp.ColaboradorAutorizadoId
			   	   ,Usuario = tmp.Usuario
				  ,Trail = tmp.Trail
					FROM @Tablatemp tmp WHERE [Despachos].[RegistrosDispersiones].[Id] = tmp.[Id];

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
