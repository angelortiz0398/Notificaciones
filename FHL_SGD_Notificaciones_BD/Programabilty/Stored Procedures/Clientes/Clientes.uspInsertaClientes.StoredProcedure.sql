USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspInsertaClientes]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Clientes].[uspInsertaClientes] 
	@Json varchar(MAX) = NULL

AS
BEGIN
-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
        Id int,
        RazonSocial VARCHAR(300),
        Rfc VARCHAR(14),
        AxaptaId varchar(50),
        Usuario varchar(150),
        Trail VARCHAR(MAX),
        RegistroNuevo BIT DEFAULT 1
    )
    INSERT INTO #TablaTmp(Id,RazonSocial,Rfc,AxaptaId,Usuario,Trail)
    SELECT * FROM OPENJSON (@Json)
    WITH
    (
        Id int,
        RazonSocial VARCHAR(300),
        Rfc VARCHAR(14),
        AxaptaId VARCHAR(50),
        Usuario VARCHAR(150),
        Trail VARCHAR(MAX)
    )
        --se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
        Update #TablaTmp set RegistroNuevo = 0
        FROM #TablaTmp
        JOIN Clientes.Clientes on #TablaTmp.Id = Clientes.Id
        
        	-- Inserta la información y complementa con campos con información predefinida
            INSERT INTO Clientes.Clientes(Id,RazonSocial,RFC,AxaptaId,Usuario,Eliminado,FechaCreacion,Trail)
            SELECT
                Id,
                RazonSocial,
                Rfc,
                AxaptaId,
                Usuario,
                1,
                CURRENT_TIMESTAMP,
                Trail
            FROM #TablaTmp
            		WHERE RegistroNuevo = 1;

	
			

			Update Clientes.Clientes 
			set RazonSocial = Tem.RazonSocial,
			RFC = Tem.Rfc,
			AxaptaId = Tem.AxaptaId
			From Clientes.Clientes 
			join #TablaTmp Tem on Tem.Id = Clientes.Id
			Where Tem.RegistroNuevo = 0;

            -- Elimina la tabla temporal
                DROP TABLE #TablaTmp;

END			
GO
