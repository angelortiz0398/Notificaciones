USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspInsertaHidrosina]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Combustibles].[uspInsertaHidrosina] 
	@Medidor varchar(50) = NULL,
    @PrecioPorUnidadVolumen bigint = NULL,
    @Total bigint = NULL,
    @VehiculoId VARCHAR(50) = NULL,
    @ProveedorId VARCHAR(50) = NULL,
    @Fecha DATETIME = null,
    @TipoCombustibleId varchar(50) = null,
    @Comentarios varchar(250) = null,
    @Referencia varchar(250) = null
AS


BEGIN
	-- Variables de control
	DECLARE @Resultado	INT = 0;
	DECLARE @JsonSalida VARCHAR(MAX) = '';
	DECLARE @Mensaje	VARCHAR(MAX) = '';
	declare @Usuario varchar(150) = 'Hidrosina';
	declare @dateLocal datetime = (SELECT DATEADD(ss, DATEDIFF(ss, getutcdate(), @Fecha), GETdATE()));
	declare @IVA numeric(18,2) = @Total * 0.16;
	declare @LITROS numeric(18,2) = @Total / @PrecioPorUnidadVolumen;
	declare @TRAIL varchar(MAX) = (select @Medidor as [meter], @PrecioPorUnidadVolumen as [price_per_volume],
									@Total as [total], @VehiculoId as [vehicle_id], @ProveedorId as [vendor_id],
									@Fecha as [date], @TipoCombustibleId as [fuelt_type_id],
									@Comentarios as [comments], @Referencia as [reference] for json path);
	--declare @IEPS numeric(18,2) = 

	-- Validación de parámetros
	IF @Medidor IS NULL OR @PrecioPorUnidadVolumen IS NULL OR @Total IS NULL OR @VehiculoId IS NULL or @Fecha is null
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se han enviado los parametros necesarios para guardar la Bitacora de Combustible,';
			GOTO SALIDA;
		END


	-- Inserta la Bitacora de Combustible
	BEGIN TRANSACTION
		BEGIN
			BEGIN TRY
			-- Inserta el registro(SELECT DATEADD(ss, DATEDIFF(ss, getutcdate(), (SELECT DATEADD(ss, j.gmt, '19700101'))), GETdATE()))
				insert into Combustibles.BitacorasCombustibles (FechaRegistro,Costo,CostoTotal,FechaCarga,Comentario,Referencia,Usuario,Eliminado,
				FechaCreacion,IVA, Litros, Trail)
				values (GETDATE(),@PrecioPorUnidadVolumen,@Total,@dateLocal,@Comentarios,@Referencia,@Usuario,1,
				GETDATE(),@IVA, @LITROS, @TRAIL)				
			-- Recupera el Identificador con el cual se insertó el registro
				SET @Resultado = (select coalesce(max(id),1) from Combustibles.BitacorasCombustibles);
				SET @Mensaje = 'La Bitacora de Combustible se guardó correctamente.';
				SET @JsonSalida = (SELECT @Resultado AS [Resultado], @Mensaje AS [Mensaje] FOR JSON PATH);
				COMMIT;
			END TRY
			BEGIN CATCH
				SET @Resultado = ERROR_NUMBER() * -1;
				SET @Mensaje = ERROR_MESSAGE();
				SET @JsonSalida = (SELECT @Resultado AS [Resultado], @Mensaje AS [Mensaje] FOR JSON PATH);
				ROLLBACK;
			END CATCH
		END

	-- Devuelve el resultado de la inserción de la Bitacora de Combustible
	SALIDA:
		select @JsonSalida as JsonSalida;
END
GO
