USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketsDisponibles]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [Despachos].[uspObtenerTicketsDisponibles]
as
Begin
	--No regresar dato de filas afectadas
	--SET NOCOUNT ON;
	WITH Disponibles AS (
		SELECT Tickets.*
			,JSON_QUERY((SELECT Clientes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
			,JSON_QUERY((SELECT Destinatarios.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Destinatarios
			,JSON_QUERY((SELECT Tipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoVehiculo
			,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta
			,JSON_QUERY((SELECT TiposCustodias.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCustodia
		FROM Despachos.Tickets Tickets
		LEFT JOIN Clientes.Clientes Clientes ON Clientes.Id = Tickets.ClienteId
		LEFT JOIN Clientes.Destinatarios Destinatarios ON Destinatarios.Id = Tickets.DestinatariosId
		LEFT JOIN Vehiculos.Tipos Tipos ON Tipos.Id = Tickets.TipoVehiculoId
		LEFT JOIN Operadores.Rutas Rutas ON Rutas.Id = Tickets.RutaId
		LEFT JOIN Despachos.TiposCustodias TiposCustodias ON TiposCustodias.Id = Tickets.TipoCustodiaId
		WHERE Tickets.Id NOT IN (
			-- Tickets no entregados que no están en TicketsAsignados
			SELECT TicketsNoEntregados.TicketId
			FROM Despachos.TicketsNoEntregados TicketsNoEntregados
			LEFT JOIN Despachos.TicketsAsignados TicketsAsignados ON TicketsNoEntregados.DespachoId = TicketsAsignados.DespachoId
			WHERE TicketsAsignados.DespachoId IS NULL
			-- Falta agregar validacion con Reasignacion de Tickets donde valide si ya estan reasignados para poderlos si quiera mostrar
		) AND Tickets.Id NOT IN (
			-- Tickets asignados que no son borradores
			SELECT TicketsAsignados.TicketId
			FROM Despachos.TicketsAsignados TicketsAsignados
			INNER JOIN Despachos.Despachos Despachos ON Despachos.Id = TicketsAsignados.DespachoId
			WHERE Despachos.Borrador = 0 
		) AND (Tickets.EstatusId = 1 OR Tickets.EstatusId = 5) -- Trae todos los tickets que su estatus estan en cola o en no entregados
		)
	--Inicia la construccion del JSON
	SELECT (SELECT COUNT(*) FROM Disponibles) as TotalRows,
		(
		SELECT *
			FROM Disponibles
		FOR JSON AUTO) AS JsonSalida;
end
GO
