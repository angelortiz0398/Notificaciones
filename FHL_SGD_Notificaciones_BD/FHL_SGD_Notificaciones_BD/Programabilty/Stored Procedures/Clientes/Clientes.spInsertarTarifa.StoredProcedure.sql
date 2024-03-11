USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[spInsertarTarifa]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Clientes].[spInsertarTarifa]
    @TipoTarifaClienteId BIGINT = 0,
    @ClienteId BIGINT = 0,
    @GrupoUnidad VARCHAR(5000) = NULL,
    @TipoServicioId INT = 0,
    @ServicioAdicional VARCHAR(max) = NULL,
    @ParametroId INT = 0,
    @Dedicado BIT = false,
    @IVA INT = 0,
    @Colaborador VARCHAR(5000) = NULL,
    @FechaVigenciaInicial DATETIME = NULL,
    @FechaVigenciaFinal DATETIME = NULL,
    @Usuario VARCHAR(150) = NULL,
    @Trail VARCHAR(MAX) = NULL
AS

SELECT * from Clientes.Tarifas

BEGIN 

    -- Variables de control
        DECLARE @Resultado	INT = 0;
        DECLARE @Mensaje VARCHAR(MAX) = 'La tarifa se guardó correctamente.';
    -- Validación de parámetros
	IF @TipoServicioId IS NULL OR @ClienteId IS NULL OR @GrupoUnidad IS NULL OR @TipoServicioId IS NULL OR @ServicioAdicional IS NULL OR @ParametroId IS NULL OR @FechaVigenciaInicial IS NULL OR @FechaVigenciaFinal  IS NULL 
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se han enviado los parametros necesarios para guardar o actualizar el destinatario,';
			GOTO SALIDA;
		END

    --Inserta o actualiza la Tarifa
    BEGIN TRANSACTION
                BEGIN
                    BEGIN TRY 
                        --Inserta el registro 
                        INSERT INTO Clientes.Tarifas(TipoTarifaClienteId,ClienteId,GrupoUnidad,TipoServicioId,ServicioAdicional,ParametroId,Dedicado,IVA,Colaborador,FechaVigenciaInicial,FechaVigenciaFinal,Usuario,FechaCreacion,Eliminado,Trail)
                        VALUES (@TipoTarifaClienteId,@ClienteId,@GrupoUnidad,@TipoServicioId,@ServicioAdicional,@ParametroId,@Dedicado,@IVA,@Colaborador,@FechaVigenciaInicial,@FechaVigenciaFinal,@Usuario,GETDATE(),1,@Trail)
                                    
                        SET @Mensaje = 'La tarifa se guardó correctamente.';
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
