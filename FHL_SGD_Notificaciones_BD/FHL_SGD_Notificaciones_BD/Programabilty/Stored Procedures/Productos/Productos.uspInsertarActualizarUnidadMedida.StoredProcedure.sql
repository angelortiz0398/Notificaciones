USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Productos].[uspInsertarActualizarUnidadMedida]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Productos].[uspInsertarActualizarUnidadMedida] 
	@ClaveUnidadMedida varchar(50) = NULL,
    @Nombre varchar(200) = NULL,
    @Trail varchar(max)
    
AS
SELECT * from Productos.UnidadesMedidas
BEGIN
	-- Variables de control
	DECLARE @Resultado	VARCHAR = '';
	DECLARE @Mensaje	VARCHAR(MAX) = 'La unida de medida se guardó correctamente.';

	


	-- Inserta o actualiza el Cliente
	BEGIN TRANSACTION
			IF NOT EXISTS (select ClaveUnidadMedida from Productos.UnidadesMedidas where ClaveUnidadMedida = @ClaveUnidadMedida)
				BEGIN
					BEGIN TRY
						-- Inserta el registro
						INSERT INTO Productos.UnidadesMedidas (ClaveUnidadMedida,Nombre,ClaveUnidadSAT,Eliminado,FechaCreacion,Trail)
						VALUES (@ClaveUnidadMedida,@Nombre,@ClaveUnidadMedida,1,GETDATE(),@Trail)
				
						-- Recupera el Identificador con el cual se insertó el registro
						SET @Resultado = @ClaveUnidadMedida;
						SET @Mensaje = 'ELa unida de medida se guardó correctamente.';
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
						UPDATE Productos.UnidadesMedidas 
						set ClaveUnidadMedida = @ClaveUnidadMedida,
						Nombre = @Nombre
						WHERE ClaveUnidadMedida = @ClaveUnidadMedida

						SET @Resultado = @ClaveUnidadMedida;
						SET @Mensaje = 'La unida de medida se actualizó correctamente.';
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
