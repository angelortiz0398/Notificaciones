USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertarActualizarEliminarTicketsAsignados]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Febrero 2024
-- Description:	Obtiene los registros de la tabla de almacenes
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertarActualizarEliminarTicketsAsignados] 
	@Json varchar(MAX) = NULL                     
AS
BEGIN
	SET NOCOUNT ON;
    -- Variables de control
    DECLARE @Resultado  INT = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = 'Los tickets asignados se guardaron y eliminaron correctamente.';
	-- Variable para almacenar la cantidad de registros insertados
	DECLARE @RegistrosInsertados INT;
	-- Variable para almacenar la cantidad de registros actualizados
	DECLARE @RegistrosActualizados INT;
	-- Variable para almacenar la cantidad de registros eliminados
	DECLARE @RegistrosEliminados INT;
    -- Validación de parámetros
    IF @Json IS NULL 
        BEGIN
            SET @Resultado = -1;
            SET @Mensaje = 'No se han enviado los parametros necesarios para guardar, actualizar o eliminar los tickets asignados';
            --GOTO SALIDA;
        END
	ELSE IF ISJSON(@Json) = 0
			BEGIN
				-- La información pasada como parámetro no es una cadena JSON válida
				SET @Resultado = -2;
				SET @Mensaje = 'La información de los tickets asignados no está en formato JSON esperado';
				--GOTO SALIDA;				
			END;
					-- Crea una tabla temporal para recuperarlos  Tickets la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaTransferidoEstatus(
		Id bigint ,
		TicketId bigint NOT NULL )
		-- Crea una tabla temporal para recuperar Eliminar Tickets la información del JSON que se recibe como parámetro
	CREATE TABLE #TablaEliminar(
		Id bigint ,
		DespachoId bigint NOT NULL,
		TicketId bigint NOT NULL )
	-- Se inserta en la tabla temporal #TablaEliminar a partir del json 
	INSERT INTO #TablaEliminar(DespachoId, TicketId)
	SELECT * FROM OPENJSON (@Json)
	WITH
	(		
		DespachoOrigenId bigint,
		TicketId bigint		
	)
	-- Se inserta en la tabla temporal #TablaTransferidoEstatus a partir del json 
	INSERT INTO #TablaTransferidoEstatus(TicketId)
	SELECT * FROM OPENJSON (@Json)
	WITH
	(		
		TicketId bigint		
	)
	--OBTENER LOS IDS DE TA
	Update  TE Set Id = TA.Id
	from #TablaEliminar TE INNER JOIN Despachos.TicketsAsignados TA
	ON TE.DespachoId = TA.DespachoId AND TE.TicketId = TA.TicketId
	--OBTENER LOS IDS DE Tickets
	Update  TT Set Id = Ticket.Id
	from #TablaTransferidoEstatus TT INNER JOIN Despachos.Tickets Ticket
	ON  TT.TicketId = Ticket.Id
	
	--	-- Crea una tabla temporal para recuperar la información del JSON que se recibe como parámetro
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
	---- Se inserta en la tabla temporal a partir del json 
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
	---- Se actualiza el campo para validar si el registro es nuevo para que se inserte en la tabla
		Update #TablaTmp set RegistroNuevo = 0
		FROM #TablaTmp
		JOIN Despachos.TicketsAsignados on #TablaTmp.Id = TicketsAsignados.Id

   -- Inserta la información de aquellos que encuentra que son tickets nuevos y complementa con campos con información predefinida
	BEGIN TRANSACTION;
	BEGIN TRY	
	--Se inserta los Registros a TA
	INSERT INTO Despachos.TicketsAsignados(
		DespachoId
		,TicketId
		,Orden
		,FolioEta
		,Transferido
		,DespachoOrigenId
		,Usuario
		,Eliminado
		,FechaCreacion
		,Trail)
	SELECT
		DespachoId
		,TicketId
		,Orden
		,FolioEta
		,Transferido
		,DespachoOrigenId
		,Usuario
		, 1
		, CURRENT_TIMESTAMP
		,Trail
	FROM #TablaTmp
            WHERE #TablaTmp.Id = 0;
	-- Almacena la cantidad de registros insertados
	SET @RegistrosInsertados = @@ROWCOUNT;

	-- Seccion en donde se actualizan los registros que ya existian pero solo con la informacion que enviamos
	UPDATE Despachos.TicketsAsignados
	SET Orden = tmp.Orden
		,FolioEta = tmp.FolioEta
		,Transferido = tmp.Transferido
		,DespachoOrigenId = tmp.DespachoOrigenId
		,Usuario = tmp.Usuario
		,Trail = tmp.Trail
	FROM #TablaTmp tmp
	WHERE Despachos.TicketsAsignados.[Id] = tmp.[Id]
		AND tmp.RegistroNuevo = 0;
	COMMIT;
	END TRY
	BEGIN CATCH
		SET @Resultado = -1;
		SET @Mensaje = 'Hubo un error para guardar los registros';
		ROLLBACK;
		GOTO SALIDA;
	END CATCH
	-- Almacena la cantidad de registros actualizados
	SET @RegistrosActualizados = @@ROWCOUNT;

	-- Se validara que se insertaron o actualizaron la misma cantidad de tickets asignados que se enviaron Y SE ELIMINAN LOS REGISTROS ANTERIORES
	IF	((@RegistrosInsertados + @RegistrosActualizados) = (SELECT COUNT(Id) FROM #TablaTmp))
	BEGIN
		SET @Resultado = 0;
		SET @Mensaje = 'Los tickets asignados se guardaron correctamente.';
		--Eliminar registros Insertados
		DELETE FROM Despachos.TicketsAsignados WHERE Id IN(SELECT Id FROM #TablaEliminar);
		--Actualizar estatus de los tickets Transferidos
		UPDATE Ticket SET Ticket.EstatusId = 6 FROM Despachos.Tickets Ticket where Id IN(SELECT Id from #TablaTransferidoEstatus);
		
	END
	ELSE
	BEGIN
		SET @Resultado = -1;
		SET @Mensaje = 'Los registros que se insertaron/actualizaron no coinciden con los recibidos en el json';
	END

	-- Elimina la tabla temporal
	DROP TABLE #TablaTmp;
	DROP TABLE #TablaEliminar;

    -- Devuelve el resultado de la inserción o actualización del ticket asignado
	
    SALIDA:
        SELECT @Resultado AS TotalRows, @Mensaje AS JsonSalida
END

GO
