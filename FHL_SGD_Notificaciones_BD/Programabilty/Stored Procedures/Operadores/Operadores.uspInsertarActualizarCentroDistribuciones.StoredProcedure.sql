USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspInsertarActualizarCentroDistribuciones]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Operadores].[uspInsertarActualizarCentroDistribuciones] 
                                    @Id bigint,
                                    @Nombre varchar(100),
                                    @Descripcion varchar(400),
                                    @Geolocalizacion varchar(100),
                                    @Usuario varchar(150),
                                    @Eliminado bit,
                                    @Trail varchar(max)
                                    
                                 
AS


BEGIN
    -- Variables de control
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'El Centro se guardó correctamente.';

    -- Validación de parámetros
    IF @Id IS NULL OR @Nombre IS NULL 
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para guardar o actualizar el Centro,';
            GOTO SALIDA;
        END


    -- Inserta o actualiza el CentroDistribucion
    BEGIN TRANSACTION
            IF NOT EXISTS (select id from Operadores.CentrosDistribuciones where id = @Id )
                BEGIN
                    BEGIN TRY
                        -- Inserta el registro
                        INSERT INTO Operadores.CentrosDistribuciones (Id,Nombre,Descripcion,Geolocalizacion,Usuario,Eliminado,FechaCreacion,Trail)
                        VALUES (@Id,@Nombre,@Descripcion,@Geolocalizacion,@Usuario,1,GETDATE(),@Trail)
                
                        -- Recupera el Identificador con el cual se insertó el registro
                        SET @Resultado = @Id;
                        SET @Mensaje = 'El Centro se guardó correctamente.';
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
                        UPDATE Operadores.CentrosDistribuciones 
                        set 
                        Nombre = @Nombre,
                        Descripcion = @Descripcion,
                        Geolocalizacion = @Geolocalizacion,
                        Usuario = @Usuario,
                        Eliminado = 1,
                        Trail = @Trail
                        WHERE Id = @Id

                        SET @Resultado = @Id;
                        SET @Mensaje = 'El Centro se actualizó correctamente.';
                        COMMIT;
                    END TRY

                    BEGIN CATCH
                        SET @Resultado = ERROR_NUMBER() * -1;
                        SET @Mensaje = ERROR_MESSAGE();
                        ROLLBACK;
                    END CATCH
                END
            END
            

    -- Devuelve el resultado de la inserción o actualización del CentroDistribucion
    SALIDA:
        SELECT @Resultado AS Resultado, @Mensaje AS Mensaje

GO
