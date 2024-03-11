USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerNotificaciones]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Enero 2024
CREATE procedure [Notificaciones].[uspObtenerNotificaciones]
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
			SET @pageSize = (SELECT MAX(Id) FROM [Notificaciones].[Notificaciones]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Notificaciones.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Notificaciones.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Nombre
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Nombre')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Notificaciones.Nombre) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo CategoriasNotificacionesId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'CategoriasNotificacionesId')
			BEGIN
				SET @condicion = @condicion + 'Notificaciones.CategoriasNotificacionesId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
				[Id] [bigint] NULL,
				[CategoriasNotificacionesId] [bigint] NULL,
				[Nombre] [varchar](250) NULL,
				[Activada] [bit] NULL,
				[Condiciones] [varchar](max) NULL,
				[Reglas] [varchar](max) NULL,
				[ListaContactos] [varchar](max) NULL,
				[NotificarPorId] [bigint] NULL,
				[Usuario] [varchar](150) NULL,
				[Eliminado] [bit] NULL,
				[FechaCreacion] [datetime] NULL,
				[Trail] [varchar](max) NULL,
				[CategoriasNotificaciones] [varchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			
			SELECT Notificaciones.[Id]
				  ,Notificaciones.[CategoriasNotificacionesId]
				  ,Notificaciones.[Nombre]
				  ,Notificaciones.[Activada]
				  ,Notificaciones.[Condiciones]
				  ,Notificaciones.[Reglas]
				  ,Notificaciones.[ListaContactos]
				  ,Notificaciones.[NotificarPorId]
				  ,Notificaciones.[Usuario]
				  ,Notificaciones.[Eliminado]
				  ,Notificaciones.[FechaCreacion]
				  ,Notificaciones.[Trail]				 
				  ,JSON_QUERY((SELECT Notificaciones.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Notificaciones
			  FROM [Notificaciones].[Notificaciones] Notificaciones
			  	LEFT JOIN Notificaciones.CategoriasNotificaciones CategoriasNotificaciones ON CategoriasNotificaciones.Id = Notificaciones.CategoriasNotificacionesId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				 PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			   [Id]
			  ,[CategoriasNotificacionesId]
			  ,[Nombre]
			  ,[Activada]
			  ,[Condiciones]
			  ,[Reglas]
			  ,[ListaContactos]
			  ,[NotificarPorId]
			  ,[Usuario]
			  ,[Eliminado]
			  ,[FechaCreacion]
			  ,[Trail]
			  ,[CategoriasNotificaciones]
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Notificaciones].[Notificaciones] Notificaciones ' + @condicion;
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
