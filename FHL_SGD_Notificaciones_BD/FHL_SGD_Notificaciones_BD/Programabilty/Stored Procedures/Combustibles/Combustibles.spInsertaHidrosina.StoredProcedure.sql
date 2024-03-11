USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[spInsertaHidrosina]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Combustibles].[spInsertaHidrosina] 
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
	DECLARE @JsonRespuesta VARCHAR(MAX) = '';
	DECLARE @Mensaje	VARCHAR(MAX) = 'La Bitacora de Combustible se guardó correctamente.';
	DECLARE @Id INT = 1;
	declare @Usuario varchar(150) = 'Hidrosina';

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
			-- Inserta el registro
				insert into SGD_V1.Combustibles.BitacorasCombustibles (Costo,CostoTotal,FechaCarga,Comentario,Referencia,Usuario,Eliminado,FechaCreacion)
				values (@PrecioPorUnidadVolumen,@Total,@Fecha,@Comentarios,@Referencia,@Usuario,1,GETDATE())
				set @Id = (select coalesce(max(id),1) from SGD_V1.Combustibles.BitacorasCombustibles);
			-- Recupera el Identificador con el cual se insertó el registro
				SET @Resultado = @Id;
				SET @Mensaje = 'La Bitacora de Combustible se guardó correctamente.';
				SET @JsonRespuesta = (SELECT @Resultado AS [Resultado], @Mensaje AS [Mensaje] FOR JSON PATH);
				COMMIT;
			END TRY
			BEGIN CATCH
				SET @Resultado = ERROR_NUMBER() * -1;
				SET @Mensaje = ERROR_MESSAGE();
				SET @JsonRespuesta = (SELECT @Resultado AS [Resultado], @Mensaje AS [Mensaje] FOR JSON PATH);
				ROLLBACK;
			END CATCH
		END

	-- Devuelve el resultado de la inserción de la Bitacora de Combustible
	SALIDA:
		select @JsonRespuesta;
END
GO
