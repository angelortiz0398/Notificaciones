USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspActualizarEliminarEstatus]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspActualizarEliminarEstatus]
	@IdTicket int,
	@IdDespacho int
AS
BEGIN	
 -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
		---=== primer caso, se elimina el registro en la tabla de TA ===---	
	Declare @IdTA int			
	SET @IdTA = (		
					Select ASIGNADO.Id
					FROM Despachos.TicketsAsignados ASIGNADO
					WHERE ASIGNADO.TicketId = @IdTicket and ASIGNADO.DespachoId = @IdDespacho AND ASIGNADO.Eliminado =1
				)
				--Eliminado Logico del registro de la Tabla Ticket Asignado
	UPDATE Despachos.TicketsAsignados SET Eliminado = 0 WHERE Id = @IdTA;
	--Actualizacion de Estatus de los tickets
	UPDATE Despachos.Tickets SET EstatusId = 6 WHERE Id = @IdTicket;
	---=== Selecciona  registro de  Tabla TA ===---
	SELECT(	
	
	--Regresar el registro como Objeto
	Select  Despachoid, TicketId ,ASIGNADO.Eliminado
					FROM Despachos.TicketsAsignados ASIGNADO
					WHERE ASIGNADO.TicketId = @IdTicket and ASIGNADO.DespachoId = @IdDespacho and ASIGNADO.Id =@IdTA
					--PARA REGRASAR UN OBJETO 
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	) AS JsonSalida
END
GO
