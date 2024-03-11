USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[UspInsertarActualizarExpedienteDocumentos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Clientes].[UspInsertarActualizarExpedienteDocumentos]
    @Id BIGINT,
    @ExpedienteId BIGINT,
    @TipoDocumentoId BIGINT,
    @Usuario VARCHAR(150),
    @Eliminado bit,
    @FechaCreacion DATETIME,
    @Trail VARCHAR(MAX)
AS

select * from GestorDocumentos.ExpedienteDocumentos
BEGIN 

    -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'EL expediente documento se guardó correctamente.';

    --Inserta o actualiza el Tipo de documento
    BEGIN TRANSACTION
            IF NOT EXISTS (select id from GestorDocumentos.ExpedienteDocumentos where id = @Id )
                BEGIN
                    BEGIN TRY 
                        --Inserta el registro 
                        INSERT INTO GestorDocumentos.ExpedienteDocumentos(Id,ExpedienteId,TipoDocumentoId,Usuario,FechaCreacion,Eliminado,Trail)
                        VALUES (@Id,@ExpedienteId,@TipoDocumentoId,@Usuario,GETDATE(),1,@Trail)
                                    
                        SET @Mensaje = 'EL expediente documento se guardó correctamente.';
                        COMMIT;
                    END TRY

                    BEGIN CATCH
                        SET @Resultado = ERROR_NUMBER() * -1;
                        SET @Mensaje = ERROR_MESSAGE();
                        ROLLBACK
                    END CATCH
                END
           

           
    -- Devuelve el resultado de la inserción o actualización del destinatario
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END
GO
