USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketsManifiesto]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerTicketsManifiesto]
	@DespachoId int
as
BEGIN	
 -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
	-- Selecciona los datos que deseas en el resultado JSON
	SELECT
			(
		--------------------------------------------------------------
		--SE SELECCIONA EL FOLIOTICKET DEL MANIFIESTO CORRESPONDIENTE
		--------------------------------------------------------------
		
		SELECT
				TICKETS.Id 
				, FolioTicket 
				, Asignados.DespachoId
		FROM [Despachos].[Tickets] TICKETS
		inner join [Despachos].[TicketsAsignados] Asignados
		ON Asignados.TicketId = TICKETS.Id
		where DespachoId = @DespachoId and Asignados.Eliminado = 1
		FOR JSON AUTO
		)AS JsonSalida
		
END 
GO
