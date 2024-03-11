USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspInsertarActualizarEmbalaje]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[uspInsertarActualizarEmbalaje] 
	@ClaveEmbalaje varchar(50) = NULL,
    @Nombre varchar(200) = NULL,
    @Trail varchar(max)
    
AS

BEGIN
	-- Variables de control
	DECLARE @Resultado	VARCHAR = '';
	DECLARE @Mensaje	VARCHAR(MAX) = 'El Embalaje se guardó correctamente.';

	


	-- Inserta o actualiza el Cliente
	BEGIN TRANSACTION
			IF NOT EXISTS (select ClaveEmbalaje from Productos.Embalajes where ClaveEmbalaje = @ClaveEmbalaje)
				BEGIN
					BEGIN TRY
						-- Inserta el registro
						INSERT INTO Productos.Embalajes (ClaveEmbalaje,Nombre,ClaveEmbalajeSAT,Eliminado,FechaCreacion,Trail)
						VALUES (@ClaveEmbalaje,@Nombre,@ClaveEmbalaje,1,GETDATE(),@Trail)
				
						-- Recupera el Identificador con el cual se insertó el registro
						SET @Resultado = @ClaveEmbalaje;
						SET @Mensaje = 'El Embalaje se guardó correctamente.';
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
						UPDATE Productos.Embalajes 
						set ClaveEmbalaje = @ClaveEmbalaje,
						Nombre = @Nombre
						WHERE ClaveEmbalaje = @ClaveEmbalaje

						SET @Resultado = @ClaveEmbalaje;
						SET @Mensaje = 'El Embalaje se actualizó correctamente.';
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
