USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspInsertarActualizarPeligroso]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[uspInsertarActualizarPeligroso] 
	@ClavePeligroso varchar(50) = NULL,
    @Nombre varchar(200) = NULL,
    @Trail varchar(max)
    
AS

BEGIN
	-- Variables de control
	DECLARE @Resultado	VARCHAR = '';
	DECLARE @Mensaje	VARCHAR(MAX) = 'El material peligroso se guardó correctamente.';

	


	-- Inserta o actualiza el Cliente
	BEGIN TRANSACTION
			IF NOT EXISTS (select ClavePeligroso from Productos.Peligrosos where ClavePeligroso = @ClavePeligroso)
				BEGIN
					BEGIN TRY
						-- Inserta el registro
						INSERT INTO Productos.Peligrosos (ClavePeligroso,Nombre,ClavePeligrosoSAT,Eliminado,FechaCreacion,Trail)
						VALUES (@ClavePeligroso,@Nombre,@ClavePeligroso,1,GETDATE(),@Trail)
				
						-- Recupera el Identificador con el cual se insertó el registro
						SET @Resultado = @ClavePeligroso;
						SET @Mensaje = 'El material peligroso se guardó correctamente.';
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
						UPDATE Productos.Peligrosos 
						set @ClavePeligroso = @ClavePeligroso,
						Nombre = @Nombre
						WHERE ClavePeligroso = @ClavePeligroso

						SET @Resultado = @ClavePeligroso;
						SET @Mensaje = 'El material peligroso se actualizó correctamente.';
						COMMIT;
					END TRY

					BEGIN CATCH
						SET @Resultado = ERROR_NUMBER() * -1;
						SET @Mensaje = ERROR_MESSAGE();
						ROLLBACK;
					END CATCH
				END
			END

	-- Devuelve el resultado de la inserción o actualización del Cliente
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
GO
