USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[spInsertaProducto]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[spInsertaProducto] 
	@Id bigint = NULL,
    @ClaveInterna VARCHAR(50),
    @ClaveProductoSAT VARCHAR(50),
    @ClaveUnidadSAT VARCHAR(50),
    @UnidadMedidaId BIGINT,
    @Nombre VARCHAR(250),
    @MaterialPeligroso bit,
	@PeligrosoId BIGINT,
	@UNId BIGINT,
	@PesoUnitario NUMERIC,
	@EmbalajeId BIGINT,
    @Usuario VARCHAR(150),
	@Trail VARCHAR(MAX)
AS


BEGIN
	-- Variables de control
	DECLARE @Resultado	INT = 0;
	DECLARE @Mensaje	VARCHAR(MAX) = 'El producto se guardó correctamente.';

	-- Validación de parámetros
	IF @Id IS NULL 
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se han enviado los parametros necesarios para guardar o actualizar el Producto,';
			GOTO SALIDA;
		END


	-- Inserta o actualiza el Cliente
	BEGIN TRANSACTION
			IF NOT EXISTS (select id from Productos.Productos where id = @Id )
				BEGIN
					BEGIN TRY
						-- Inserta el registro
						INSERT INTO Productos.Productos (id,ClaveInterna, ClaveProductoSAT,ClaveUnidadSAT,UnidadMedidaId,Nombre,MaterialPeligroso,PeligrosoId,UNId,PesoUnitario,EmbalajeId,Eliminado,FechaCreacion,Usuario,Trail)
						VALUES (@Id,@ClaveInterna,@ClaveProductoSAT,@ClaveUnidadSAT,@UnidadMedidaId,@Nombre,@MaterialPeligroso,@PeligrosoId,@UNId,@PesoUnitario,@EmbalajeId,1,GETDATE(),@Usuario,@Trail)
				
						-- Recupera el Identificador con el cual se insertó el registro
						SET @Resultado = @Id;
						SET @Mensaje = 'El Producto se guardó correctamente.';
						COMMIT;
					END TRY

					BEGIN CATCH
						SET @Resultado = ERROR_NUMBER() * -1;
						SET @Mensaje = ERROR_MESSAGE();
						ROLLBACK;
					END CATCH
				END

			ELSE
				BEGIN
					BEGIN TRY
						-- Actualiza el registro
						UPDATE Productos.Productos 
						set ClaveInterna = @ClaveInterna,
						ClaveProductoSAT = @ClaveProductoSAT,
                        ClaveUnidadSAT = @ClaveUnidadSAT,
						UnidadMedidaId = @UnidadMedidaId,
						Nombre = @Nombre,
						MaterialPeligroso = @MaterialPeligroso,
						PeligrosoId = @PeligrosoId,
						PesoUnitario = @PesoUnitario,
						EmbalajeId = @EmbalajeId,
                        Usuario = @Usuario
						WHERE Id = @Id

						SET @Resultado = @Id;
						SET @Mensaje = 'El Producto se actualizó correctamente.';
						COMMIT;
					END TRY

					BEGIN CATCH
						SET @Resultado = ERROR_NUMBER() * -1;
						SET @Mensaje = ERROR_MESSAGE();
						ROLLBACK;
					END CATCH
				END
			END

	-- Devuelve el resultado de la inserción o actualización del Producto
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
GO
