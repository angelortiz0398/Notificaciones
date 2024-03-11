USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspInsertarActualizarColaboradoresModificado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Operadores].[uspInsertarActualizarColaboradoresModificado] 
	@Json varchar(MAX) = NULL
AS
BEGIN
-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		Id bigint NOT NULL,
		Nombre varchar(500) NULL,
		RFC varchar(13) NULL,
		Identificacion varchar(20) NULL,
		TipoPerfilesId bigint NULL,
		CentroDistribucionesId bigint NULL,
		NSS varchar(30) NULL,
		CorreoElectronico varchar(150) NULL,
		Telefono varchar(15) NULL,
		IMEI varchar(20) NULL,
		Habilidades varchar(2000) NULL,
		TipoVehiculo varchar(2000) NULL,
		Estado bit NULL,
		Comentarios varchar(1000) NULL,
		UltimoAcceso datetime NULL,
		Usuario varchar(150) NULL,
		Eliminado bit NULL,
		FechaCreacion datetime NULL,
		Trail varchar(max) NULL,
        RegistroNuevo BIT DEFAULT 1
    )
    INSERT INTO #TablaTmp(Id,RazonSocial,Rfc,AxaptaId,Usuario,Trail)
    SELECT * FROM OPENJSON (@Json)
    WITH
    (
		Id bigint,
		Nombre varchar(500),
		RFC varchar(13),
		Identificacion varchar(20),
		TipoPerfilesId bigint,
		CentroDistribucionesId bigint,
		NSS varchar(30),
		CorreoElectronico varchar(150),
		Telefono varchar(15),
		IMEI varchar(20),
		Habilidades varchar(2000),
		TipoVehiculo varchar(2000),
		Estado bit,
		Comentarios varchar(1000),
		UltimoAcceso datetime,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max)
    )
        --se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
        Update #TablaTmp set RegistroNuevo = 0
        FROM #TablaTmp
        JOIN Operadores.Colaboradores on #TablaTmp.Id = Colaboradores.Id
        


        	-- Inserta la información y complementa con campos con información predefinida
            INSERT INTO Operadores.Colaboradores(
				[Id]
			   ,[Nombre]
			   ,[RFC]
			   ,[Identificacion]
			   ,[TipoPerfilesId]
			   ,[CentroDistribucionesId]
			   ,[NSS]
			   ,[CorreoElectronico]
			   ,[Telefono]
			   ,[IMEI]
			   ,[Habilidades]
			   ,[TipoVehiculo]
			   ,[Estado]
			   ,[Comentarios]
			   ,[UltimoAcceso]
			   ,[Usuario]
			   ,[Eliminado]
			   ,[FechaCreacion]
			   ,[Trail])
            SELECT
                [Id]
			   ,[Nombre]
			   ,[RFC]
			   ,[Identificacion]
			   ,[TipoPerfilesId]
			   ,[CentroDistribucionesId]
			   ,[NSS]
			   ,[CorreoElectronico]
			   ,[Telefono]
			   ,[IMEI]
			   ,[Habilidades]
			   ,[TipoVehiculo]
			   ,[Estado]
			   ,[Comentarios]
			   ,[UltimoAcceso]
			   ,[Usuario]
			   , 1
			   , CURRENT_TIMESTAMP
			   ,[Trail]
            FROM #TablaTmp
            		WHERE RegistroNuevo = 1;

			UPDATE Operadores.Colaboradores
			SET
				[Nombre] = tmp.[Nombre],
				[RFC] = tmp.[RFC],
				[Identificacion] = tmp.[Identificacion],
				[TipoPerfilesId] = tmp.[TipoPerfilesId],
				[CentroDistribucionesId] = tmp.[CentroDistribucionesId],
				[NSS] = tmp.[NSS],
				[CorreoElectronico] = tmp.[CorreoElectronico],
				[Telefono] = tmp.[Telefono],
				[IMEI] = tmp.[IMEI],
				[Habilidades] = tmp.[Habilidades],
				[TipoVehiculo] = tmp.[TipoVehiculo],
				[Estado] = tmp.[Estado],
				[Comentarios] = tmp.[Comentarios],
				[UltimoAcceso] = tmp.[UltimoAcceso],
				[Usuario] = tmp.[Usuario],
				[FechaCreacion] = CURRENT_TIMESTAMP,
				[Trail] = tmp.[Trail]
			FROM #TablaTmp tmp
			WHERE Operadores.Colaboradores.[Id] = tmp.[Id]
				AND tmp.RegistroNuevo = 0;

            -- Elimina la tabla temporal
                DROP TABLE #TablaTmp;

END			
GO
