USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GestorDocumentos].[UspInsertarActualizarExpedienteDocumento]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GestorDocumentos].[UspInsertarActualizarExpedienteDocumento]
    @Id BIGINT,
    @ExpedienteId BIGINT,
    @TipoDocumentoId BIGINT,
    @Usuario VARCHAR(150),
    @Trail VARCHAR(MAX)
AS

BEGIN 

    -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'EL expediente documento se guardó correctamente.';

    --Inserta o actualiza el Tipo de documento
            IF NOT EXISTS (select id from GestorDocumentos.ExpedienteDocumentos where id = @Id )
                BEGIN
                        --Inserta el registro 
                        INSERT INTO GestorDocumentos.ExpedienteDocumentos(Id,ExpedienteId,TipoDocumentoId,Usuario,FechaCreacion,Eliminado,Trail)
                        VALUES (@Id,@ExpedienteId,@TipoDocumentoId,@Usuario,GETDATE(),1,@Trail)
                         						
                        
                        SET @Resultado = ERROR_NUMBER() * -1;
                        SET @Mensaje = ERROR_MESSAGE();
                END
           

           
    -- Devuelve el resultado de la inserción o actualización del destinatario
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END
GO
