USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerTarifas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Enero 2024
CREATE procedure [Clientes].[uspObtenerTarifas]
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
			SET @pageSize = (SELECT MAX(Id) FROM [Clientes].[Tarifas]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Tarifas.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Tarifas.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo TipoTarifaClienteId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'TipoTarifaClienteId')
			BEGIN
				SET @condicion = @condicion + 'Tarifas.TipoTarifaClienteId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Si se quiere buscar por el campo ClienteId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ClienteId')
			BEGIN
				SET @condicion = @condicion + 'Tarifas.ClienteId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			[Id] [bigint] NULL,
			[TipoTarifaClienteId] [bigint] NULL,
			[ClienteId] [bigint] NULL,
			[GrupoUnidad] [varchar](5000) NULL,
			[TipoServicioId] [int] NULL,
			[ServicioAdicional] [varchar](max) NULL,
			[ParametroId] [int] NULL,
			[Dedicado] [bit] NULL,
			[IVA] [int] NULL,
			[Colaborador] [varchar](5000) NULL,
			[FechaVigenciaInicial] [datetime] NULL,
			[FechaVigenciaFinal] [datetime] NULL,
			[Usuario] [varchar](150) NULL,
			[FechaCreacion] [datetime] NULL,
			[Eliminado] [bit] NULL,
			[Trail] [varchar](max) NULL,
			TipoTarifaCliente [nvarchar](max) NULL,
			Cliente [nvarchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT Tarifas.[Id]
					,Tarifas.[TipoTarifaClienteId]
					,Tarifas.[ClienteId]
					,Tarifas.[GrupoUnidad]
					,Tarifas.[TipoServicioId]
					,Tarifas.[ServicioAdicional]
					,Tarifas.[ParametroId]
					,Tarifas.[Dedicado]
					,Tarifas.[IVA]
					,Tarifas.[Colaborador]
					,Tarifas.[FechaVigenciaInicial]
					,Tarifas.[FechaVigenciaFinal]
					,Tarifas.[Usuario]
					,Tarifas.[FechaCreacion]
					,Tarifas.[Eliminado]
					,Tarifas.[Trail]	
					--Tablas relacionadas
				  ,JSON_QUERY((SELECT TiposTarifasCliente.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoTarifaCliente
				  ,JSON_QUERY((SELECT Cliente.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
			  FROM [Clientes].[Tarifas] Tarifas
			  	LEFT JOIN Clientes.Clientes Cliente ON Cliente.Id = Tarifas.ClienteId
				LEFT JOIN Clientes.TiposTarifasClientes TiposTarifasCliente ON TiposTarifasCliente.Id = Tarifas.TipoTarifaClienteId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				 PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			  [Id]
			  ,[TipoTarifaClienteId]
			  ,[ClienteId]
			  ,[GrupoUnidad]
			  ,[TipoServicioId]
			  ,[ServicioAdicional]
			  ,[ParametroId]
			  ,[Dedicado]
			  ,[IVA]
			  ,[Colaborador]
			  ,[FechaVigenciaInicial]
			  ,[FechaVigenciaFinal]
			  ,[Usuario]
			  ,[FechaCreacion]
			  ,[Eliminado]
			  ,[Trail]
			  ,TipoTarifaCliente
			  ,Cliente
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Clientes].[Tarifas] Tarifas ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		CREATE TABLE #TotalRows(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO #TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;



		-- Retorna TotalRows y los registros
		SELECT * FROM #TablaTemporal
		SELECT TotalRows FROM #TotalRows

		-- Eliminar las tablas temporales
		DROP TABLE #TablaTemporal;
		DROP TABLE #FiltrosTemporal;
		DROP TABLE #TotalRows;
end
GO
