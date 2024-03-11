USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspObtenerColaboradores]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Angel Ortiz
CREATE procedure [Operadores].[uspObtenerColaboradores]
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0			-- Parametro para buscar por un Id
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Variable para almacenar los campos que contengan un json y que se deserializaran
		DECLARE @camposObjetos nvarchar(max) = '';
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM [Operadores].[Colaboradores]);
			SET @camposObjetos = ',null
						,null
						';
		END;
		ELSE
		BEGIN 
			SET @camposObjetos = ',JSON_QUERY((SELECT TipoPerfil.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoPerfiles
				  ,JSON_QUERY((SELECT CentroDistribucion.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS CentroDistribuciones';
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Colaboradores.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Colaboradores.Id = ' + CAST(@Id AS nvarchar(20));
		END

		-- Crea una tabla temporal para almacenar los filtros
		DECLARE @FiltrosTemporal TABLE(
				Campo		varchar(20) NOT NULL
			);
		
		IF (@filtros <> '')
		BEGIN
			-- Inserta en la tabla temporal los campos por los que se va a filtrar
			INSERT INTO @FiltrosTemporal (Campo) SELECT * FROM OPENJSON (@filtros)
			WITH
			(
				Campo		varchar(20)
			)

			-- Se agrega ' AND (' cuando exista mas de un filtro por el que buscar
			IF (SELECT COUNT(Campo) FROM @FiltrosTemporal) > 0
			BEGIN
				SET @condicion = @condicion + ' AND (';
			END
			-- Si se quiere buscar por el campo Nombre
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'Nombre')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Colaboradores.Nombre) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo RFC
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'RFC')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Colaboradores.RFC) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Identificacion
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'Identificacion')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Colaboradores.Identificacion) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo TipoPerfilesId
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'TipoPerfilesId')
			BEGIN
				SET @condicion = @condicion + 'Colaboradores.TipoPerfilesId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		DECLARE @TablaTemporal TABLE(
			[Id] [bigint] NULL,
			[Nombre] [varchar](500) NULL,
			[Rfc] [varchar](13) NULL,
			[Identificacion] [varchar](20) NULL,
			[TipoPerfilesId] [bigint] NULL,
			[CentroDistribucionesId] [bigint] NULL,
			[Nss] [varchar](30) NULL,
			[CorreoElectronico] [varchar](150) NULL,
			[Telefono] [varchar](15) NULL,
			[Imei] [varchar](20) NULL,
			[Habilidades] [varchar](2000) NULL,
			[TipoVehiculo] [varchar](2000) NULL,
			[Estado] [bit] NULL,
			[Comentarios] [varchar](1000) NULL,
			[UltimoAcceso] [datetime] NULL,
			[Usuario] [varchar](150) NULL,
			[Eliminado] [bit] NULL,
			[FechaCreacion] [datetime] NULL,
			[Trail] [varchar](max) NULL,
			TipoPerfiles nvarchar(max) NULL,
			CentroDistribuciones nvarchar(max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT Colaboradores.[Id]
				  ,Colaboradores.[Nombre]
				  ,Colaboradores.[RFC]
				  ,Colaboradores.[Identificacion]
				  ,Colaboradores.[TipoPerfilesId]
				  ,Colaboradores.[CentroDistribucionesId]
				  ,Colaboradores.[NSS]
				  ,Colaboradores.[CorreoElectronico]
				  ,Colaboradores.[Telefono]
				  ,Colaboradores.[IMEI]
				 -- ,(
					--	STUFF(
					--		(
					--			SELECT '', '' + Nombre 
					--			FROM Operadores.HabilidadesColaboradores
					--			WHERE Id IN (
					--				SELECT CAST(JSON_VALUE(value, ''$.Id'') AS INT)
					--				FROM OPENJSON
					--					(
					--						(
					--							SELECT Habilidades
					--							FROM Operadores.Colaboradores
					--							WHERE Colaboradores.Id = ColaboradoresPivote.Id
					--						), ''$''
					--					)
					--			)
					--			FOR XML PATH ('''')
					--		)
					--	,1,2,'''')
					--) AS Habilidades
				  ,Colaboradores.Habilidades
				 -- ,(
					--	STUFF(
					--		(
					--			SELECT '', '' + Nombre 
					--			FROM Vehiculos.Tipos
					--			WHERE Id IN (
					--				SELECT CAST(JSON_VALUE(value, ''$.Id'') AS INT)
					--				FROM OPENJSON
					--					(
					--						(
					--							SELECT TipoVehiculo
					--							FROM Operadores.Colaboradores
					--							WHERE Colaboradores.Id = ColaboradoresPivote.Id
					--						), ''$''
					--					)
					--			)
					--			FOR XML PATH ('''')
					--		)
					--	,1,2,'''')
					--) AS TipoVehiculo
				  ,Colaboradores.TipoVehiculo
				  ,Colaboradores.[Estado]
				  ,Colaboradores.[Comentarios]
				  ,Colaboradores.[UltimoAcceso]
				  ,Colaboradores.[Usuario]
				  ,Colaboradores.[Eliminado]
				  ,Colaboradores.[FechaCreacion]
				  ,Colaboradores.[Trail]
			    -----------------------------------------------------------------------------------
				' + @camposObjetos +'
			  FROM  [Operadores].[Colaboradores] Colaboradores
					INNER JOIN Operadores.Colaboradores ColaboradoresPivote ON Colaboradores.Id = ColaboradoresPivote.Id
					LEFT JOIN Operadores.TiposPerfiles TipoPerfil ON TipoPerfil.Id = Colaboradores.TipoPerfilesId
					LEFT JOIN Operadores.CentrosDistribuciones CentroDistribucion ON CentroDistribucion.Id = Colaboradores.CentroDistribucionesId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO @TablaTemporal (
			[Id]
			,[Nombre]
			,[Rfc]
			,[Identificacion]
			,[TipoPerfilesId]
			,[CentroDistribucionesId]
			,[Nss]
			,[CorreoElectronico]
			,[Telefono]
			,[Imei]
			,[Habilidades]
			,[TipoVehiculo]
			,[Estado]
			,[Comentarios]
			,[UltimoAcceso]
			,[Usuario]
			,[Eliminado]
			,[FechaCreacion]
			,[Trail]
			,TipoPerfiles
			,CentroDistribuciones
		)
		EXEC sp_executesql @return_query;

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Operadores].[Colaboradores] Colaboradores ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		DECLARE @TotalRows TABLE(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO @TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna los registros y luego TotalRows
		SELECT * FROM @TablaTemporal;
		SELECT TotalRows FROM @TotalRows AS TotalRows;
end
GO
