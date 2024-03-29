USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[UspInsertarActualizarDocumentos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Clientes].[UspInsertarActualizarDocumentos]
    @Id BIGINT,
    @Nombre VARCHAR(500),
    @TipoFormato VARCHAR(150),
    @Usuario VARCHAR(150),
    @Eliminado bit,
    @FechaCreacion DATETIME,
    @Trail VARCHAR(MAX)
AS


BEGIN 

    -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'EL tipo documento se guardó correctamente.';

    --Inserta o actualiza el Tipo de documento
    BEGIN TRANSACTION
            IF NOT EXISTS (select id from Clientes.Destinatarios where id = @Id )
                BEGIN
                    BEGIN TRY 
                        --Inserta el registro 
                        INSERT INTO GestorDocumentos.TiposDocumentos(Id,Nombre,TipoFormato,Usuario,FechaCreacion,Eliminado,Trail)
                        VALUES (@Id,@Nombre,@TipoFormato,@Usuario,GETDATE(),1,@Trail)
                                    
                        SET @Mensaje = 'EL tipo de documento se guardó correctamente.';
                        COMMIT;
                    END TRY

                    BEGIN CATCH
                        SET @Resultado = ERROR_NUMBER() * -1;
                        SET @Mensaje = ERROR_MESSAGE();
                        ROLLBACK
                    END CATCH
                END
            ELSE
                BEGIN
                    BEGIN TRY
                        --Actualiza el registro
                        UPDATE GestorDocumentos.TiposDocumentos
                        SET Nombre = @Nombre,
                        TipoFormato = @TipoFormato
                        where Id = @Id

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
