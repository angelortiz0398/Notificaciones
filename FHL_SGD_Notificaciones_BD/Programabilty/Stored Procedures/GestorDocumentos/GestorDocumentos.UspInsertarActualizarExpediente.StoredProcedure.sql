USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GestorDocumentos].[UspInsertarActualizarExpediente]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GestorDocumentos].[UspInsertarActualizarExpediente]
    @Id BIGINT,
    @Nombre VARCHAR(150),
    @ReferenciaId BIGINT,
    @ConfiguracionId BIGINT,
    --@ExpedienteDocumentos VARCHAR(max),
    @Usuario VARCHAR(150),
    @Trail VARCHAR(MAX)
AS

BEGIN 

    -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'EL expediente se guardó correctamente.';

    --Inserta o actualiza el Tipo de documento
            IF NOT EXISTS (select id from GestorDocumentos.Expedientes where id = @Id )
                BEGIN
                        --Inserta el registro 
                        INSERT INTO GestorDocumentos.Expedientes(Id,Nombre,ReferenciaId,ConfiguracionId,Usuario,FechaCreacion,Eliminado,Trail)
                        VALUES (@Id,@Nombre,@ReferenciaId,@ConfiguracionId,@Usuario,GETDATE(),1,@Trail)
                                    
                        

                        SET @Resultado = ERROR_NUMBER() * -1;
                        SET @Mensaje = ERROR_MESSAGE();
                       
                END
            ELSE

           
    -- Devuelve el resultado de la inserción o actualización del destinatario
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END
GO
