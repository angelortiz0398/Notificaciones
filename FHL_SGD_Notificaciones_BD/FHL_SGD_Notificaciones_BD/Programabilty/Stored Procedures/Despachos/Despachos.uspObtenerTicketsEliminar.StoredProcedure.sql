USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketsEliminar]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Diciembre 2023
-- Description:	Obtiene El registro que se filtre por los parametros ingresados
CREATE PROCEDURE [Despachos].[uspObtenerTicketsEliminar]
	@ManifiestoId int,
	@TicketId int
as
BEGIN
SET NOCOUNT ON;
SELECT
	(
		
	SELECT Top 1
		 [TicketsAsignados].[Id]
		,[TicketsAsignados].[DespachoId]
		,[TicketsAsignados].[TicketId]		
		,[TicketsAsignados].[Transferido]
		,[TicketsAsignados].[DespachoOrigenId]		
		FROM [Despachos].[TicketsAsignados] TicketsAsignados
		WHERE  Eliminado = 1 AND TicketsAsignados.DespachoId = @ManifiestoId and TicketsAsignados.TicketId = @TicketId
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER  ) AS JsonSalida
		
END
GO
