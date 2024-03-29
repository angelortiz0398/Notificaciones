USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarSegurosDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Procedimiento para insertar o actualizar registros de SegurosDespachos
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarSegurosDespachos]
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
	Folio bigint NOT NULL,
	ClienteId bigint NULL,
	NumeroControl int NULL,
	DescripcionMercancia varchar(max) NULL,
	Cantidad int NULL,
	ValorMercancia numeric(18, 2) NULL,
	SumaAsegurada numeric(18, 2) NULL,
	TarifaPoliza numeric(18, 2) NULL,
	DerechoPoliza numeric(18, 2) NULL,
	TotalCobrar numeric(18, 2) NULL,
	Origen varchar(500) NULL,
	DestinoId bigint NULL,
	MedioTransporteId bigint NULL,
	MedidasSeguridad varchar(500) NULL,
	FechaSalida datetime NULL,
	FechaLLegada datetime NULL,
	Contenido varchar(5000) NULL,
	Usuario varchar(150) NULL,
	Eliminado bit NULL,
	FechaCreacion datetime NULL,
	Trail varchar(max) NULL
			);
	

	-- 3. En la tabla temporal creada guardaremos la información de nuestro JSON
		INSERT INTO @Tablatemp(
	  Id
      ,DespachoId
      ,Folio
      ,ClienteId
      ,NumeroControl
      ,DescripcionMercancia
      ,Cantidad
      ,ValorMercancia
      ,SumaAsegurada
      ,TarifaPoliza
      ,DerechoPoliza
      ,TotalCobrar
      ,Origen
      ,DestinoId
      ,MedioTransporteId
      ,MedidasSeguridad
      ,FechaSalida
      ,FechaLLegada
      ,Contenido
      ,Usuario
      ,Eliminado
      ,FechaCreacion
      ,Trail
			)	 
			SELECT * FROM OPENJSON(@Lista)
			WITH(
	Id bigint  ,
	DespachoId bigint  ,
	Folio bigint  ,
	ClienteId bigint ,
	NumeroControl int ,
	DescripcionMercancia varchar(max) ,
	Cantidad int ,
	ValorMercancia numeric(18, 2) ,
	SumaAsegurada numeric(18, 2) ,
	TarifaPoliza numeric(18, 2) ,
	DerechoPoliza numeric(18, 2) ,
	TotalCobrar numeric(18, 2) ,
	Origen varchar(500) ,
	DestinoId bigint ,
	MedioTransporteId bigint ,
	MedidasSeguridad varchar(500) ,
	FechaSalida datetime ,
	FechaLlegada datetime ,
	Contenido varchar(5000) ,
	Usuario varchar(150) ,
	Eliminado bit ,
	FechaCreacion datetime ,
	Trail varchar(max) 
				);

		
		-- 4. Instrucción para insertar registros nuevos
		BEGIN TRANSACTION;
		BEGIN TRY
			INSERT INTO [Despachos].[SegurosDespachos](
			 
      DespachoId
      ,Folio
      ,ClienteId
      ,NumeroControl
      ,DescripcionMercancia
      ,Cantidad
      ,ValorMercancia
      ,SumaAsegurada
      ,TarifaPoliza
      ,DerechoPoliza
      ,TotalCobrar
      ,Origen
      ,DestinoId
      ,MedioTransporteId
      ,MedidasSeguridad
      ,FechaSalida
      ,FechaLLegada
      ,Contenido
      ,Usuario
      ,Eliminado
      ,FechaCreacion
      ,Trail
			) 
			SELECT
		   	 DespachoId
     		,Folio
     		,ClienteId
    		,NumeroControl
    		,DescripcionMercancia
    		,Cantidad
    		,ValorMercancia
    		,SumaAsegurada
    		,TarifaPoliza
    		,DerechoPoliza
     		,TotalCobrar
      		,Origen
     		,DestinoId
    		,MedioTransporteId
      		,MedidasSeguridad
     		,FechaSalida
     		,FechaLLegada
    		,Contenido
      		,Usuario
				,1
				,CURRENT_TIMESTAMP
				,Trail
				FROM @Tablatemp WHERE Id = 0;

			-- 5. Almacena la cantidad de registros insertados
			SET @RegistrosInsertados = @@ROWCOUNT;


			-- 6. Instrucción para actualizar registros
			UPDATE [Despachos].[SegurosDespachos]
			   SET DespachoId = tmp.DespachoId
			   	   ,Folio = tmp.Folio
			   	   ,ClienteId = tmp.ClienteId
			   	   ,NumeroControl = tmp.NumeroControl
			   	   ,DescripcionMercancia = tmp.DescripcionMercancia
			   	   ,Cantidad = tmp.Cantidad
			   	   ,ValorMercancia = tmp.ValorMercancia
			   	   ,SumaAsegurada = tmp.SumaAsegurada
			   	   ,TarifaPoliza = tmp.TarifaPoliza
			   	   ,DerechoPoliza = tmp.DerechoPoliza
			   	   ,TotalCobrar = tmp.TotalCobrar
			   	   ,Origen = tmp.Origen
			   	   ,DestinoId = tmp.DestinoId
			   	   ,MedioTransporteId = tmp.MedioTransporteId
			   	   ,MedidasSeguridad = tmp.MedidasSeguridad
			   	   ,FechaSalida = tmp.FechaSalida
			   	   ,FechaLLegada = tmp.FechaLLegada
			   	   ,Contenido = tmp.Contenido
			   	   ,Usuario = tmp.Usuario
				  ,Trail = tmp.Trail
					FROM @Tablatemp tmp WHERE [Despachos].[SegurosDespachos].[Id] = tmp.[Id];

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
