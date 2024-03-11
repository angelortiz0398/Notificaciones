USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerTiposTarifasClientes]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Enero 2024
CREATE procedure [Clientes].[uspObtenerTiposTarifasClientes]
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   nvarchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0			-- Parametro para buscar por un Id
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM [Clientes].[TiposTarifasClientes]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE TiposTarifasClientes.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND TiposTarifasClientes.Id = ' + CAST(@Id AS nvarchar(20));
		END
		-- Crea una tabla temporal para almacenar los filtros
		CREATE TABLE #FiltrosTemporal(
				Campo		varchar(20)  NULL
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
			-- Si se quiere buscar por el campo Nombre
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Nombre')
			BEGIN
				SET @condicion = @condicion + 'LOWER(TiposTarifasClientes.Nombre) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo TipoTarifaClienteId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'TipoTarifaId')
			BEGIN
				SET @condicion = @condicion + 'TiposTarifasClientes.TipoTarifaId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Si se quiere buscar por el campo TipoPesoId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'TipoPesoId')
			BEGIN
				SET @condicion = @condicion + 'TiposTarifasClientes.TipoPesoId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Si se quiere buscar por el campo TipoEmpaqueId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'TipoEmpaqueId')
			BEGIN
				SET @condicion = @condicion + 'TiposTarifasClientes.TipoEmpaqueId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Si se quiere buscar por el campo PrioridadId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'PrioridadId')
			BEGIN
				SET @condicion = @condicion + 'TiposTarifasClientes.PrioridadId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			[Id] [bigint] NULL,
			[Nombre] [varchar](500) NULL,
			[IdInterno] [varchar](20) NULL,
			[TipoTarifaId] [bigint]  NULL,
			[MonedaIdCosto] [int] NULL,
			[Costo] [decimal](18, 2) NULL,
			[CostoNoArmada] [numeric](18, 0) NULL,
			[CostoArmada] [numeric](18, 0) NULL,
			[ValorMinimoArmada] [numeric](18, 0) NULL,
			[TipoPesoId] [bigint] NULL,
			[TipoEmpaqueId] [bigint] NULL,
			[TipoVehiculoId] [bigint] NULL,
			[PrioridadId] [bigint] NULL,
			[ParadaIntermedia] [varchar](5000) NULL,
			[Origen] [varchar](5000) NULL,
			[Destino] [varchar](5000) NULL,
			[PromesaEntrega] [int] NULL,
			[DiasEntregaId] [varchar](5000) NULL,
			[MonedaIdGastoOperativoPermitido] [int] NULL,
			[GastoOperativoPermitido] [decimal](18, 2) NULL,
			[MonedaIdCancelacionConManifiesto] [int] NULL,
			[CancelacionConManifiesto] [decimal](18, 2) NULL,
			[MonedaIdCancelacionConBorrador] [int] NULL,
			[CancelacionConBorrador] [decimal](18, 2) NULL,
			[MonedaIdCostoParadaIntermedia] [int] NULL,
			[CostoParadaIntermedia] [decimal](18, 2) NULL,
			[MonedaIdCostoRetorno] [int] NULL,
			[CostoRetorno] [decimal](18, 2) NULL,
			[TipoCustodia] [varchar](500) NULL,
			[Utilidad] [numeric](18, 0) NULL,
			[ProveedorId] [bigint] NULL,
			[FechaVigenciaInicial] [datetime] NULL,
			[FechaVigenciaFinal] [datetime] NULL,
			[Usuario] [varchar](150) NULL,
			[Eliminado] [bit] NULL,
			[FechaCreacion] [datetime] NULL,
			[Trail] [varchar](max) NULL,
			[TipoTarifa] [varchar](max) NULL,
			[TipoPeso] [varchar](max) NULL,
			[TipoEmpaque] [varchar](max) NULL,
			[Prioridad] [varchar](max) NULL,
			[Proveedor] [varchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT TiposTarifasClientes.[Id]
				  ,TiposTarifasClientes.[Nombre]
				  ,TiposTarifasClientes.[IdInterno]
				  ,TiposTarifasClientes.[TipoTarifaId]
				  ,TiposTarifasClientes.[MonedaIdCosto]
				  ,TiposTarifasClientes.[Costo]
				  ,TiposTarifasClientes.[CostoNoArmada]
				  ,TiposTarifasClientes.[CostoArmada]
				  ,TiposTarifasClientes.[ValorMinimoArmada]
				  ,TiposTarifasClientes.[TipoPesoId]
				  ,TiposTarifasClientes.[TipoEmpaqueId]
				  ,TiposTarifasClientes.[TipoVehiculoId]
				  ,TiposTarifasClientes.[PrioridadId]
				  ,TiposTarifasClientes.[ParadaIntermedia]
				  ,TiposTarifasClientes.[Origen]
				  ,TiposTarifasClientes.[Destino]
				  ,TiposTarifasClientes.[PromesaEntrega]
				  ,TiposTarifasClientes.[DiasEntregaId]
				  ,TiposTarifasClientes.[MonedaIdGastoOperativoPermitido]
				  ,TiposTarifasClientes.[GastoOperativoPermitido]
				  ,TiposTarifasClientes.[MonedaIdCancelacionConManifiesto]
				  ,TiposTarifasClientes.[CancelacionConManifiesto]
				  ,TiposTarifasClientes.[MonedaIdCancelacionConBorrador]
				  ,TiposTarifasClientes.[CancelacionConBorrador]
				  ,TiposTarifasClientes.[MonedaIdCostoParadaIntermedia]
				  ,TiposTarifasClientes.[CostoParadaIntermedia]
				  ,TiposTarifasClientes.[MonedaIdCostoRetorno]
				  ,TiposTarifasClientes.[CostoRetorno]
				  ,TiposTarifasClientes.[TipoCustodia]
				  ,TiposTarifasClientes.[Utilidad]
				  ,TiposTarifasClientes.[ProveedorId]
				  ,TiposTarifasClientes.[FechaVigenciaInicial]
				  ,TiposTarifasClientes.[FechaVigenciaFinal]
				  ,TiposTarifasClientes.[Usuario]
				  ,TiposTarifasClientes.[Eliminado]
				  ,TiposTarifasClientes.[FechaCreacion]
				  ,TiposTarifasClientes.[Trail]
					--Tablas relacionadas
				  ,JSON_QUERY((SELECT TipoTarifa.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoTarifa
				  ,JSON_QUERY((SELECT TipoPeso.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoPeso
				  ,JSON_QUERY((SELECT TipoEmpaque.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoEmpaque
				  ,JSON_QUERY((SELECT Prioridad.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Prioridad
				  ,JSON_QUERY((SELECT Proveedor.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Proveedor

			  FROM [Clientes].[TiposTarifasClientes] TiposTarifasClientes
			  	LEFT JOIN Clientes.TiposTarifas TipoTarifa ON TipoTarifa.Id = TiposTarifasClientes.TipoTarifaId
				LEFT JOIN Clientes.TiposPesos TipoPeso ON TipoPeso.Id = TiposTarifasClientes.TipoPesoId
				LEFT JOIN Clientes.TiposEmpaques TipoEmpaque ON TipoEmpaque.Id = TiposTarifasClientes.TipoEmpaqueId
				LEFT JOIN Clientes.Prioridades Prioridad ON Prioridad.Id = TiposTarifasClientes.PrioridadId
				LEFT JOIN Clientes.Proveedores Proveedor ON Proveedor.Id = TiposTarifasClientes.ProveedorId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				 PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			  [Id]
			  ,[Nombre]
			  ,[IdInterno]
			  ,[TipoTarifaId]
			  ,[MonedaIdCosto]
			  ,[Costo]
			  ,[CostoNoArmada]
			  ,[CostoArmada]
			  ,[ValorMinimoArmada]
			  ,[TipoPesoId]
			  ,[TipoEmpaqueId]
			  ,[TipoVehiculoId]
			  ,[PrioridadId]
			  ,[ParadaIntermedia]
			  ,[Origen]
			  ,[Destino]
			  ,[PromesaEntrega]
			  ,[DiasEntregaId]
			  ,[MonedaIdGastoOperativoPermitido]
			  ,[GastoOperativoPermitido]
			  ,[MonedaIdCancelacionConManifiesto]
			  ,[CancelacionConManifiesto]
			  ,[MonedaIdCancelacionConBorrador]
			  ,[CancelacionConBorrador]
			  ,[MonedaIdCostoParadaIntermedia]
			  ,[CostoParadaIntermedia]
			  ,[MonedaIdCostoRetorno]
			  ,[CostoRetorno]
			  ,[TipoCustodia]
			  ,[Utilidad]
			  ,[ProveedorId]
			  ,[FechaVigenciaInicial]
			  ,[FechaVigenciaFinal]
			  ,[Usuario]
			  ,[Eliminado]
			  ,[FechaCreacion]
			  ,[Trail]
			  ,[TipoTarifa]
			  ,[TipoPeso]
			  ,[TipoEmpaque]
			  ,[Prioridad]
			  ,[Proveedor]
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Clientes].[TiposTarifasClientes] TiposTarifasClientes ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		CREATE TABLE #TotalRows(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO #TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna TotalRows y los registros solicitados
		SELECT * FROM #TablaTemporal
		SELECT TotalRows FROM #TotalRows
		-- Eliminar las tablas temporales
		DROP TABLE #TablaTemporal;
		DROP TABLE #FiltrosTemporal;
		DROP TABLE #TotalRows;
end
GO
