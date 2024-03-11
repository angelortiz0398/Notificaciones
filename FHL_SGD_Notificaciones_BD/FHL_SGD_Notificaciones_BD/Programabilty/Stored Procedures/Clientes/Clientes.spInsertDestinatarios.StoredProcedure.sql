USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[spInsertDestinatarios]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Clientes].[spInsertDestinatarios] 
	@Id bigint = NULL,
    @ClienteId bigint = NULL,
    @RFC varchar(14) = NULL,
    @RazonSocial varchar(500) = NULL,
    @Referencia varchar(500) = NULL,
    @Calle varchar (500) = NULL,
    @NumeroExterior varchar(20) = NULL,
    @NumeroInterior varchar(20) = NULL,
    @CodigoPostal int = NULL,
	@Trail varchar(max) = NULL
AS


BEGIN
	-- Variables de control
	DECLARE @Resultado	INT = 0;
	DECLARE @Mensaje	VARCHAR(MAX) = 'El destinatario se guardó correctamente.';

	-- Validación de parámetros
	IF @Id IS NULL OR @ClienteId IS NULL OR @RFC IS NULL OR @RazonSocial IS NULL OR @Referencia IS NULL OR @Calle IS NULL OR @NumeroExterior IS NULL OR @NumeroInterior IS NULL OR @CodigoPostal IS NULL OR @Trail IS NULL
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se han enviado los parametros necesarios para guardar o actualizar el destinatario,';
			GOTO SALIDA;
		END


	-- Inserta o actualiza el Destinatario
	BEGIN TRANSACTION
			IF NOT EXISTS (select id from Clientes.Destinatarios where id = @Id )
				BEGIN
					BEGIN TRY
						-- Inserta el registro
						INSERT INTO Clientes.Destinatarios (Id, ClienteId, RFC, RazonSocial, Referencia, Calle, NumeroExterior,NumeroInterior,CodigoPostal,Eliminado,FechaCreacion,Trail)
						VALUES (@Id,@ClienteId,@RFC,@RazonSocial,@Referencia,@Calle,@NumeroExterior,@NumeroInterior,@CodigoPostal,1,GETDATE(),@Trail)
				
						-- Recupera el Identificador con el cual se insertó el registro
						SET @Resultado = @Id;
						SET @Mensaje = 'El destinatario se guardó correctamente.';
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
						UPDATE Clientes.Destinatarios 
						set RFC = @RFC,
						RazonSocial = @RazonSocial,
						Referencia = @Referencia,
						Calle = @Calle,
						NumeroExterior = @NumeroExterior,
						NumeroInterior = @NumeroInterior,
						CodigoPostal = @CodigoPostal,
                        FechaCreacion = GETDATE(),
						Trail = @Trail
						WHERE Id = @Id

						SET @Resultado = @Id;
						SET @Mensaje = 'El destinatario se actualizó correctamente.';
						COMMIT;
					END TRY

					BEGIN CATCH
						SET @Resultado = ERROR_NUMBER() * -1;
						SET @Mensaje = ERROR_MESSAGE();
						ROLLBACK;
					END CATCH
				END
			END

	-- Devuelve el resultado de la inserción o actualización del destinatario
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
GO
