USE [SGD_V1]
GO
/****** Object:  StoredProcedure [NoConformidades].[uspEliminarCausasRaices]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: Enero 2024
-- Description:	Actualiza un registro en su parametro de "Eliminado" haciendo así un eliminado virtual
-- =============================================
CREATE PROCEDURE [NoConformidades].[uspEliminarCausasRaices]
	-- Parametros necesarios para realizar la eliminación virtual
	@Id bigint = null    
AS
BEGIN
	--Variables de control
	DECLARE @Resultado INT = null;
	DECLARE @Mensaje VARCHAR(MAX) = null;

	--Validar el Id no venga nulo
	IF(@Id is not null)
	BEGIN
		--Se declara el Begin Transaction por si hay un error se regrese a su estado previo la tabla a modificar
		BEGIN TRANSACTION;
		BEGIN TRY

			-- Verifica si el Id existe antes de la actualización
			IF EXISTS (SELECT 1 FROM [NoConformidades].[CausasRaices] WHERE Id = @Id)
			BEGIN
				-- Se elimina virtualmente el registro
				UPDATE [NoConformidades].[CausasRaices] SET Eliminado = 0 WHERE Id = @Id;

				-- Recupera el Id del registro eliminado virtualmente
				SET @Resultado = @Id;
				SET @Mensaje = 'El registro se eliminó correctamente.';
			END
			ELSE				
			BEGIN
				-- Recupera el Id y envía el mensaje de no localizado
				SET @Resultado = @Id;
				SET @Mensaje = 'El Id especificado no esta asociado a algún registro.';
			END

			-- Commit si todo ha ido bien
			COMMIT;		
		END TRY

		BEGIN CATCH
			-- Manejo de errores, puedes personalizar según tus necesidades
			SET @Resultado = -1; -- Puedes asignar un valor específico para indicar un error
			SET @Mensaje = 'Error al eliminar el registro: ' + ERROR_MESSAGE();

			-- Rollback en caso de error
			ROLLBACK;        
		END CATCH;
	END

	--Se regresa el resultado: Id afectado y el mesnaje : Msj satisfactorio u de error
	SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END;
GO
