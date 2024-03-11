USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GestorDocumentos].[uspInsertaExpedientesDocumento]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [GestorDocumentos].[uspInsertaExpedientesDocumento] 
	@Json varchar(MAX) = NULL

AS
BEGIN
-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
        Id int,
        ExpedienteId int,
        Expediente VARCHAR(150),
        TipoDocumentoId int,
        TipoDocumento varchar(150),
        Usuario VARCHAR(150),
        Trail VARCHAR(MAX),
        RegistroNuevo BIT DEFAULT 1
    )
    INSERT INTO #TablaTmp(Id,ExpedienteId,Expediente,TipoDocumentoId,TipoDocumento,Usuario,Trail)
    SELECT * FROM OPENJSON (@Json)
    WITH
    (
        Id int,
        ExpedienteId int,
        Expediente VARCHAR(150),
        TipoDocumentoId int,
        TipoDocumento varchar(150),
        Usuatio VARCHAR(150),
        Trail VARCHAR(MAX)
    )
        --se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
        Update #TablaTmp set RegistroNuevo = 0
        FROM #TablaTmp
        JOIN GestorDocumentos.ExpedienteDocumentos on #TablaTmp.Id = ExpedienteDocumentos.Id
        


        	-- Inserta la información y complementa con campos con información predefinida
            INSERT INTO GestorDocumentos.ExpedienteDocumentos(Id,ExpedienteId,Expediente,TipoDocumentoId,TipoDocumento,Usuario,Eliminado,FechaCreacion,Trail)
            SELECT
                Id,
                ExpedienteId,
                Expediente,
                TipoDocumentoId,
                TipoDocumento,
                Usuario,
                1,
                CURRENT_TIMESTAMP,
                Trail
            FROM #TablaTmp
            		WHERE RegistroNuevo = 1;

            -- Elimina la tabla temporal
                DROP TABLE #TablaTmp;

END			
GO
