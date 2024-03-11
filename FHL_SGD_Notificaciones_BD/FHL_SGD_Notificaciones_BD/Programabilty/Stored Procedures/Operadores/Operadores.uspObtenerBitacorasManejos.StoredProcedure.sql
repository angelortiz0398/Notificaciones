USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Operadores].[uspObtenerBitacorasManejos]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Angel Ortiz
CREATE procedure [Operadores].[uspObtenerBitacorasManejos]
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0			-- Parametro para buscar por un Id
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM [Operadores].[BitacorasManejos]);
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE BitacorasManejos.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND BitacorasManejos.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Manifiesto
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Manifiesto')
			BEGIN
				SET @condicion = @condicion + 'LOWER(BitacorasManejos.Manifiesto) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo ColaboradoresId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ColaboradoresId')
			BEGIN
				SET @condicion = @condicion + 'BitacorasManejos.ColaboradoresId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			Id bigint NULL,
			ColaboradoresId bigint NOT NULL,
			FechaInicio datetime NULL,
			FechaFin datetime NULL,
			Manifiesto varchar(20) NULL,
			KmCargado numeric(18, 2) NULL,
			KmVacio numeric(18, 2) NULL,
			Rendimiento numeric(18, 2) NULL,
			VehiculosId bigint NULL,
			Usuario varchar(150) NULL,
			Eliminado bit NULL,
			FechaCreacion datetime NULL,
			Trail varchar(max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
				SELECT
					  BitacorasManejos.Id
					  ,BitacorasManejos.ColaboradoresId
					  ,BitacorasManejos.FechaInicio
					  ,BitacorasManejos.FechaFin
					  ,BitacorasManejos.Manifiesto
					  ,BitacorasManejos.KmCargado
					  ,BitacorasManejos.KmVacio
					  ,BitacorasManejos.Rendimiento
					  ,BitacorasManejos.VehiculosId
					  ,BitacorasManejos.Usuario
					  ,BitacorasManejos.Eliminado
					  ,BitacorasManejos.FechaCreacion
					  ,BitacorasManejos.Trail
				  FROM Operadores.BitacorasManejos
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			Id
			,ColaboradoresId
			,FechaInicio
			,FechaFin
			,Manifiesto
			,KmCargado
			,KmVacio
			,Rendimiento
			,VehiculosId
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Operadores].[BitacorasManejos] BitacorasManejos ' + @condicion;
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
