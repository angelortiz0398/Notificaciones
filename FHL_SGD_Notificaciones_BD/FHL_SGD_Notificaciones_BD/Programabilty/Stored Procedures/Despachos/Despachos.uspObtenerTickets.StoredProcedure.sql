USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTickets]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Angel Ortiz
CREATE procedure [Despachos].[uspObtenerTickets]
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0,			-- Parametro para buscar por un Id
	@dateInitial	   DATETIME = NULL,     -- Parametro para filtrar por una fecha inicial sobre FechaSolicitud
	@dateFin		   DATETIME = NULL	    -- Parametro para filtra por una fecha final sobre FechaSolicitud
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Variable para almacenar los campos que contengan un json y que se deserializaran
		DECLARE @camposObjetos nvarchar(max) = '';
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM [Despachos].[Tickets]);
			SET @camposObjetos = ',null
						,null
						,null
						,null
						,null
						';
		END;
		ELSE
		BEGIN 
			SET @camposObjetos = ',JSON_QUERY((SELECT Clientes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
					  ,JSON_QUERY((SELECT Destinatarios.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Destinatarios
					  ,JSON_QUERY((SELECT Tipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoVehiculo
					  ,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta
					  ,JSON_QUERY((SELECT TiposCustodias.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCustodia';
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Tickets.Eliminado = 1';
		-- Si llegan los parametros de fecha inicial y fecha final diferente de nulo
		IF @dateInitial <> null AND @dateFin <> null
		BEGIN
			SET @condicion = @condicion + ' AND Tickets.FechaSolicitud >= ' +@dateInitial+ ' AND Tickets.FechaSolicitud <= ' + @dateFin;
		END
		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Tickets.Id = ' + CAST(@Id AS nvarchar(20));
		END

		-- Crea una tabla temporal para almacenar los filtros
		CREATE TABLE #FiltrosTemporal(
				Campo		varchar(20) NOT NULL
			);
		
		IF (@filtros <> '')
		BEGIN
			-- Inserta en la tabla temporal los campos por los que se va a filtrar
			INSERT INTO #FiltrosTemporal (Campo) SELECT * FROM OPENJSON (@filtros)
			WITH
			(
				Campo		varchar(20)
			)

			-- Se agrega ' AND (' cuando exista mas de un filtro por el que buscar
			IF (SELECT COUNT(Campo) FROM #FiltrosTemporal) > 0
			BEGIN
				SET @condicion = @condicion + ' AND (';
			END
			-- Si se quiere buscar por el campo FolioTicket
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'FolioTicket')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Tickets.FolioTicket) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Origen
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Origen')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Tickets.Origen) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo EstatusId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'EstatusId')
			BEGIN
				SET @condicion = @condicion + 'Tickets.EstatusId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
				Id bigint NOT NULL,
				FolioTicket varchar(20) NOT NULL,
				FolioTicketWMS varchar(20) NOT NULL,
				TipoFolio varchar(1) NULL,
				Origen varchar(500) NULL,
				ClienteId bigint NULL,
				DestinatariosId bigint NULL,
				Referencia varchar(50) NULL,
				SolicitaServicio varchar(150) NULL,
				FechaSolicitud datetime NULL,
				TipoSolicitudId bigint NULL,
				TipoEntregaId bigint NULL,
				Comentarios varchar(5000) NULL,
				EstatusId bigint NULL,
				TipoRecepcion varchar(1) NULL,
				Secuencia varchar(500) NULL,
				FechaSalidaEstimada datetime NULL,
				FechaPromesaLlegadaOrigen datetime NULL,
				FechaPromesaCarga datetime NULL,
				FechaPromesaEntrega datetime NULL,
				FechaPromesaRetorno datetime NULL,
				TiempoCarga time(7) NULL,
				TiempoParadaDestino time(7) NULL,
				FechaVentanaInicio datetime NULL,
				FechaVentanaFin datetime NULL,
				FechaRestriccionCirculacionInicio datetime NULL,
				FechaRestriccionCirculacionFin datetime NULL,
				Empaque varchar(max) NULL,
				Cantidad int NULL,
				SumaAsegurada numeric(18, 2) NULL,
				RutaId bigint NULL,
				TipoVehiculoId bigint NULL,
				HabilidadesVehiculo varchar(5000) NULL,
				DocumentosVehiculo varchar(5000) NULL,
				HabilidadesOperador varchar(5000) NULL,
				DocumentosOperador varchar(5000) NULL,
				HabilidadesAuxiliar varchar(5000) NULL,
				DocumentosAuxiliar varchar(5000) NULL,
				EvidenciaSalida varchar(5000) NULL,
				EvidenciaLlegada varchar(5000) NULL,
				CheckList varchar(5000) NULL,
				Maniobras int NULL,
				Peligroso varchar(150) NULL,
				Custodia varchar(150) NULL,
				CustodiaArmada varchar(150) NULL,
				TipoCustodiaId bigint NULL,
				RequiereEvidenciaSeguroSocial varchar(50) NULL,
				Seguro bit NULL,
				ServicioCobro bit NULL,
				ServicioAdicional varchar(max) NULL,
				RecepcionTicket datetime NULL,
				AsignacionManifiesto datetime NULL,
				InicioEscaneoRecepcionProducto datetime NULL,
				FinEscaneoRecepcionProducto datetime NULL,
				InicioEntregaProducto datetime NULL,
				FinEntregaProducto datetime NULL,
				DestinatariosClienteId bigint NULL,
				PrioridadId bigint NULL,
				Usuario varchar(150) NULL,
				Trail varchar(max) NOT NULL,
				FechaCreacion datetime NOT NULL,
				Eliminado bit NOT NULL,
				Cliente nvarchar(max) NULL,
				Destinatarios nvarchar(max) NULL,
				TipoVehiculo nvarchar(max) NULL,
				Ruta nvarchar(max) NULL,
				TipoCustodia nvarchar(max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
		SELECT 
					   [Tickets].[Id]
					  ,[Tickets].[FolioTicket]
					  ,[Tickets].[FolioTicketWMS]
					  ,[Tickets].[TipoFolio]
					  ,[Tickets].[Origen]
					  ,[Tickets].[ClienteId]
					  ,[Tickets].[DestinatariosId]
					  ,[Tickets].[Referencia]
					  ,[Tickets].[SolicitaServicio]
					  ,[Tickets].[FechaSolicitud]
					  ,[Tickets].[TipoSolicitudId]
					  ,[Tickets].[TipoEntregaId]
					  ,[Tickets].[Comentarios]
					  ,[Tickets].[TipoRecepcion]
					  ,[Tickets].[Secuencia]
					  ,[Tickets].[FechaPromesaLlegadaOrigen]
					  ,[Tickets].[FechaPromesaCarga]
					  ,[Tickets].[FechaPromesaEntrega]
					  ,[Tickets].[FechaPromesaRetorno]
					  ,[Tickets].[TiempoCarga]
					  ,[Tickets].[TiempoParadaDestino]
					  ,[Tickets].[FechaVentanaInicio]
					  ,[Tickets].[FechaVentanaFin]
					  ,[Tickets].[FechaRestriccionCirculacionInicio]
					  ,[Tickets].[FechaRestriccionCirculacionFin]
					  ,[Tickets].[Empaque]
					  ,[Tickets].[Cantidad]
					  ,[Tickets].[SumaAsegurada]
					  ,[Tickets].[RutaId]
					  ,[Tickets].[TipoVehiculoId]
					  ,[Tickets].[HabilidadesVehiculo]
					  ,[Tickets].[DocumentosVehiculo]
					  ,[Tickets].[HabilidadesOperador]
					  ,[Tickets].[DocumentosOperador]
					  ,[Tickets].[HabilidadesAuxiliar]
					  ,[Tickets].[DocumentosAuxiliar]
					  ,[Tickets].[EvidenciaSalida]
					  ,[Tickets].[EvidenciaLlegada]
					  ,[Tickets].[CheckList]
					  ,[Tickets].[Maniobras]
					  ,[Tickets].[Peligroso]
					  ,[Tickets].[Custodia]
					  ,[Tickets].[CustodiaArmada]
					  ,[Tickets].[TipoCustodiaId]
					  ,[Tickets].[RequiereEvidenciaSeguroSocial]
					  ,[Tickets].[Seguro]
					  ,[Tickets].[ServicioCobro]
					  ,[Tickets].[ServicioAdicional]
					  ,[Tickets].[RecepcionTicket]
					  ,[Tickets].[AsignacionManifiesto]
					  ,[Tickets].[InicioEscaneoRecepcionProducto]
					  ,[Tickets].[FinEscaneoRecepcionProducto]
					  ,[Tickets].[InicioEntregaProducto]
					  ,[Tickets].[FinEntregaProducto]
					  ,[Tickets].[PrioridadId]
					  ,[Tickets].[Usuario]
					  ,[Tickets].[Eliminado]
					  ,[Tickets].[FechaCreacion]
					  ,[Tickets].[Trail]
					  ,[Tickets].[EstatusId]
				-----------------------------------------------------------------------------------
				' + @camposObjetos + '
				-----------------------------------------------------------------------------------
				FROM Despachos.Tickets Tickets
					INNER JOIN Clientes.Clientes Clientes ON Clientes.Id = Tickets.ClienteId
					INNER JOIN Clientes.Destinatarios Destinatarios ON Destinatarios.Id = Tickets.DestinatariosId
					LEFT JOIN Vehiculos.Tipos Tipos ON Tipos.Id = Tickets.TipoVehiculoId
					LEFT JOIN Operadores.Rutas Rutas ON Rutas.Id = Tickets.RutaId
					LEFT JOIN Despachos.TiposCustodias TiposCustodias ON TiposCustodias.Id = Tickets.TipoCustodiaId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
					   [Id]
					  ,[FolioTicket]
					  ,[FolioTicketWMS]
					  ,[TipoFolio]
					  ,[Origen]
					  ,[ClienteId]
					  ,[DestinatariosId]
					  ,[Referencia]
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
					  ,[Empaque]
					  ,[Cantidad]
					  ,[SumaAsegurada]
					  ,[RutaId]
					  ,[TipoVehiculoId]
					  ,[HabilidadesVehiculo]
					  ,[DocumentosVehiculo]
					  ,[HabilidadesOperador]
					  ,[DocumentosOperador]
					  ,[HabilidadesAuxiliar]
					  ,[DocumentosAuxiliar]
					  ,[EvidenciaSalida]
					  ,[EvidenciaLlegada]
					  ,[CheckList]
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
					  ,[Usuario]
					  ,[Eliminado]
					  ,[FechaCreacion]
					  ,[Trail]
					  ,[EstatusId]
					  ,Cliente
					  ,Destinatarios
					  ,TipoVehiculo
					  ,Ruta
					  ,TipoCustodia
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[Tickets] Tickets ' + @condicion;
		PRINT @sqlQuery;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		CREATE TABLE #TotalRows(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO #TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna TotalRows y el JsonSalida
		SELECT * FROM #TablaTemporal
		SELECT TotalRows FROM #TotalRows
		-- Eliminar las tablas temporales
		DROP TABLE #TablaTemporal;
		DROP TABLE #FiltrosTemporal;
		DROP TABLE #TotalRows;
end
GO
