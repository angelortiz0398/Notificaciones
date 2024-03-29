USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketsPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Despachos].[uspObtenerTicketsPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@dateInitial	   DATETIME = NULL,
	@dateFin		   DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Tickets);
			END;
		
		;WITH CteTmp AS(
		SELECT [Tickets].[Id]
				,[FolioTicket]
				,[FolioTicketWMS]
				,[TipoFolio]
				,[Origen]
				,[Tickets].[ClienteId]
				,[DestinatariosId]
				,[Tickets].[Referencia]
				,[SolicitaServicio]
				,[FechaSolicitud]
				,[TipoSolicitudId]
				,[TipoEntregaId]
				,[Comentarios]
				,[EstatusId]
				,[TipoRecepcion]
				,[Secuencia]
				,[FechaPromesaLlegadaOrigen]
				,[FechaPromesaCarga]
				,[FechaPromesaEntrega]
				,[FechaPromesaRetorno]
				,[TiempoCarga]
				,[TiempoParadaDestino]
				,[FechaVentanaInicio]
				,[FechaVentanaFin]
				,[FechaRestriccionCirculacionInicio]
				,[FechaRestriccionCirculacionFin]
				,[Empaque]
				,[RutaId]
				,[TipoVehiculoId]
				,[HabilidadesVehiculo]
				,[DocumentosVehiculo]
				,[HabilidadesOperador]
				,[DocumentosOperador]
				,[HabilidadesAuxiliar]
				,[DocumentosAuxiliar]
				,[Tickets].[EvidenciaSalida]
				,[Tickets].[EvidenciaLlegada]
				,[Tickets].[CheckList]
				,[Maniobras]
				,[Peligroso]
				,[Custodia]
				,[CustodiaArmada]
				,[TipoCustodiaId]
				,[RequiereEvidenciaSeguroSocial]
				,[Seguro]
				,[ServicioCobro]
				,[ServicioAdicional]
				,[RecepcionTicket]
				,[AsignacionManifiesto]
				,[InicioEscaneoRecepcionProducto]
				,[FinEscaneoRecepcionProducto]
				,[InicioEntregaProducto]
				,[FinEntregaProducto]
				,[PrioridadId]
				,[Tickets].[Usuario]
				,[Tickets].[Eliminado]
				,[Tickets].[FechaCreacion]
				,[Tickets].[Trail]
				,JSON_QUERY((SELECT Clientes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
				,JSON_QUERY((SELECT Destinatarios.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Destinatarios
				,JSON_QUERY((SELECT Tipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoVehiculo
				,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta
				,JSON_QUERY((SELECT TiposCustodias.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCustodia
			FROM Despachos.Tickets Tickets
				INNER JOIN Clientes.Clientes Clientes ON Clientes.Id = Tickets.ClienteId
				INNER JOIN Clientes.Destinatarios Destinatarios ON Destinatarios.Id = Tickets.DestinatariosId
				LEFT JOIN Vehiculos.Tipos Tipos ON Tipos.Id = Tickets.TipoVehiculoId
				LEFT JOIN Operadores.Rutas Rutas ON Rutas.Id = Tickets.RutaId
				LEFT JOIN Despachos.TiposCustodias TiposCustodias ON TiposCustodias.Id = Tickets.TipoCustodiaId
			WHERE Tickets.Eliminado = 1 AND Tickets.FechaSolicitud >= @dateInitial AND Tickets.FechaSolicitud <= @dateFin
			ORDER BY FolioTicket DESC
			OFFSET (@pageIndex - 1) * @pageSize ROWS
			FETCH NEXT @pageSize ROWS ONLY
		)
	---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Tickets WHERE Tickets.Eliminado = 1 AND Tickets.FechaSolicitud >= @dateInitial AND Tickets.FechaSolicitud <= @dateFin) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;

END
GO
