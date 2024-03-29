USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketsConSeguro]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      NewlandApps
-- Create date: Septiembre del 2023
-- Description: Consulta de los tickets y su seguro en el modúlo de despacho
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerTicketsConSeguro]
    @DespachoSeleccionado BIGINT
AS
BEGIN
	-- Consulta para obtener los registros de Ticket relacionados con un Despacho específico
	--TA es de Tickets Asignados de los cuales obtendremos el DespachoId o Manifiesto al cual un ticket este asignado actualmente 
	--Consulta principal para obtener los tickets de un despacho

	--T es de Ticket, del cual obtendremos todos sus valores y asi mismo si el ticket requiere Seguro o no
	--Consulta secundaria para obtener la información de los tickets que se encontraron en tickets asignados

	--SeguroId es la propiedad que obtendremos cuando un ticket de un manifiesto asignado si requiera seguro, si es asi hara la busqueda
	--Consulta final para traer los Id de la tabla seguro
	--Le colocamos una función ISNULL para si no existe un seguro asociado el Id que nos envié sea un 0

		Select(
		SELECT TA.Id AS TicketAsignadoId
		,T.*
		,ISNULL((SELECT S.Id FROM [Despachos].[SegurosDespachos] S WHERE S.Folio = T.Id), 0) AS SeguroId
		FROM [Despachos].[TicketsAsignados] TA
		JOIN [Despachos].[Tickets] T ON TA.TicketId = T.Id
		WHERE TA.DespachoId = @DespachoSeleccionado AND T.Seguro = 1
		FOR JSON PATH
		) As JsonSalida;
		
END
GO
