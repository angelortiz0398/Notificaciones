USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerBorradoresDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Despachos].[uspObtenerBorradoresDespachos]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

		;WITH CteTmp AS(
		SELECT [BorradoresDespachos].[Id]
			  ,[Folio]
			  ,[TipoFolio]
			  ,[Origen]
			  ,[BorradoresDespachos].[ClienteId]
			  ,[DestinatariosId]
			  ,[BorradoresDespachos].[Referencia]
			  ,[SolicitaServicio]
			  ,[FechaSolicitud]
			  ,[TipoSolicitudId]
			  ,[TipoEntregaId]
			  ,[Comentarios]
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
			  ,[Ticket]
			  ,[RutaId]
			  ,[TipoVehiculoId]
			  ,[HabilidadesVehiculo]
			  ,[DocumentosVehiculo]
			  ,[HabilidadesOperador]
			  ,[DocumentosOperador]
			  ,[HabilidadesAuxiliar]
			  ,[DocumentosAuxiliar]
			  ,[BorradoresDespachos].[EvidenciaSalida]
			  ,[BorradoresDespachos].[EvidenciaLlegada]
			  ,[BorradoresDespachos].[CheckList]
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
			  ,[BorradoresDespachos].[Usuario]
			  ,[BorradoresDespachos].[Eliminado]
			  ,[BorradoresDespachos].[FechaCreacion]
			  ,[BorradoresDespachos].[Trail]
			  ,JSON_QUERY((SELECT Clientes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
			  ,JSON_QUERY((SELECT Destinatarios.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Destinatarios
			  ,JSON_QUERY((SELECT Tipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoVehiculo
			  ,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta
			  ,JSON_QUERY((SELECT TiposCustodias.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCustodia
			FROM Despachos.BorradoresDespachos BorradoresDespachos
				INNER JOIN Clientes.Clientes Clientes ON Clientes.Id = BorradoresDespachos.ClienteId
				INNER JOIN Clientes.Destinatarios Destinatarios ON Destinatarios.Id = BorradoresDespachos.DestinatariosId
				INNER JOIN Vehiculos.Tipos Tipos ON Tipos.Id = BorradoresDespachos.TipoVehiculoId
				INNER JOIN Operadores.Rutas Rutas ON Rutas.Id = BorradoresDespachos.RutaId
				INNER JOIN Despachos.TiposCustodias TiposCustodias ON TiposCustodias.Id = BorradoresDespachos.TipoCustodiaId
			WHERE BorradoresDespachos.Eliminado = 1
		)

	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Folio DESC
				FOR JSON PATH
			) AS JsonSalida;
END
GO
