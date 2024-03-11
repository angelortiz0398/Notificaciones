USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspEliminarTicketsAsignados]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspEliminarTicketsAsignados] 
	@Json varchar(MAX) = NULL                     
AS


BEGIN
    -- Variables de control
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'Los tickets asignados se eliminaron correctamente.';
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT;

    -- Validación de parámetros
    IF @Json IS NULL 
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para eliminar los tickets asignados';
            GOTO SALIDA;
        END
	ELSE IF ISJSON(@Json) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				SET @Mensaje = 'La información de los tickets asignados no está en formato JSON esperado';
				GOTO SALIDA;				
			END;

    -- Inserta o actualiza el ticket asignado

	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTmp(
		Id bigint  NOT NULL,
		DespachoId bigint NOT NULL,
		TicketId bigint NOT NULL,
		Orden int NULL,
		FolioEta varchar(30) NULL,
		Transferido bit NULL,
		DespachoOrigenId bigint NULL,
		Usuario varchar(150) NULL,
		Eliminado bit NULL,
		FechaCreacion datetime NULL,
		Trail varchar(max) NULL,
		RegistroNuevo BIT DEFAULT 1
	)
	-- Se inserta en la tabla temporal a partir del json 
	INSERT INTO #TablaTmp(Id, DespachoId, TicketId, Orden, FolioEta, Transferido, DespachoOrigenId, Usuario, Eliminado, FechaCreacion, Trail)
	SELECT * FROM OPENJSON (@Json)
	WITH
	(
		Id bigint,
		DespachoId bigint,
		TicketId bigint,
		Orden int,
		FolioEta varchar(30),
		Transferido bit,
		DespachoOrigenId bigint,
		Usuario varchar(150),
		Eliminado bit,
		FechaCreacion datetime,
		Trail varchar(max)
	)
	-- Se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
		Update #TablaTmp set RegistroNuevo = 0
		FROM #TablaTmp
		JOIN Despachos.TicketsAsignados on #TablaTmp.Id = TicketsAsignados.Id

		-- Elimina fisicamente los registros en la tabla de tickets asignados
		DELETE FROM [Despachos].[TicketsAsignados]
		WHERE TicketsAsignados.Id IN (SELECT Id FROM #TablaTmp)

		SET @Mensaje = @Json
		SET @Resultado = 0
	-- Elimina la tabla temporal
	DROP TABLE #TablaTmp;

    -- Devuelve el resultado de la inserción o actualización del ticket asignado
    SALIDA:
        SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END

GO
