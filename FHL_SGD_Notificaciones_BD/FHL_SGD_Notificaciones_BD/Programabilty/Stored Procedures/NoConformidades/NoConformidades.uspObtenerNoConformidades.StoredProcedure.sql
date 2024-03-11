USE [SGD_V1]
GO
/****** Object:  StoredProcedure [NoConformidades].[uspObtenerNoConformidades]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Enero 2024
CREATE procedure [NoConformidades].[uspObtenerNoConformidades]
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
			SET @pageSize = (SELECT MAX(Id) FROM [NoConformidades].[NoConformidades]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE NoConformidades.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND NoConformidades.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Folio
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Folio')
			BEGIN
				SET @condicion = @condicion + 'LOWER(NoConformidades.Folio) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo ManifiestosId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ManifiestosId')
			BEGIN
				SET @condicion = @condicion + 'NoConformidades.ManifiestosId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Si se quiere buscar por el campo CausasRaizId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'CausasRaizId')
			BEGIN
				SET @condicion = @condicion + 'NoConformidades.CausasRaizId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END	
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
				[Id] [bigint] NULL,
				[Folio] [varchar](50) NULL,
				[ManifiestosId] [bigint] NULL,
				[CausasRaizId] [bigint] NULL,
				[Usuario] [varchar](150) NULL,
				[Eliminado] [bit] NULL,
				[FechaCreacion] [datetime] NULL,
				[Trail] [varchar](max) NULL,
				[Manifiestos] [varchar](max) NULL,
				[CausasRaiz] [varchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT NoConformidades.[Id]
				  ,NoConformidades.[Folio]
				  ,NoConformidades.[ManifiestosId]
				  ,NoConformidades.[CausasRaizId]		 
				  ,NoConformidades.[Usuario]
				  ,NoConformidades.[Eliminado]
				  ,NoConformidades.[FechaCreacion]
				  ,NoConformidades.[Trail]

				  ,JSON_QUERY((SELECT CausasRaiz.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS CausasRaiz
				  ,JSON_QUERY((SELECT Manifiestos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Manifiestos
			  FROM [NoConformidades].[NoConformidades] NoConformidades
			  LEFT JOIN NoConformidades.CausasRaices CausasRaiz ON CausasRaiz.Id = NoConformidades.CausasRaizId
			  LEFT JOIN Despachos.Despachos Manifiestos ON Manifiestos.Id = NoConformidades.ManifiestosId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				 PRINT @return_query;

		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			  Id
			  ,Folio
			  ,ManifiestosId
			  ,CausasRaizId
			  ,Usuario
			  ,Eliminado
			  ,FechaCreacion
			  ,Trail
			  ,Manifiestos
			  ,CausasRaiz
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [NoConformidades].[NoConformidades] NoConformidades ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		CREATE TABLE #TotalRows(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO #TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna TotalRows y el JsonSalida
		SELECT
			(SELECT TotalRows FROM #TotalRows) AS TotalRows,
			(
				SELECT * FROM #TablaTemporal
				FOR JSON PATH
			) AS JsonSalida;
		-- Eliminar las tablas temporales
		DROP TABLE #TablaTemporal;
		DROP TABLE #FiltrosTemporal;
		DROP TABLE #TotalRows;
end
GO
