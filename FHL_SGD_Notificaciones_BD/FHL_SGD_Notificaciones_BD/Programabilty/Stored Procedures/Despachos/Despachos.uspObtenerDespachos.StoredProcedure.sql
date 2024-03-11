USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Angel Ortiz
CREATE procedure [Despachos].[uspObtenerDespachos]
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
			SET @pageSize = (SELECT MAX(Id) FROM [Despachos].[Despachos]);
			SET @camposObjetos = ',null
			,null
			,null
			,null
			,null
			';
		END;
		ELSE
		BEGIN 
			SET @camposObjetos = '--Json para el Objeto de Vehiculo
				,JSON_QUERY((SELECT Vehiculos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculo
				--Json Para el Objeto Operador 
				,JSON_QUERY((SELECT Operadores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Operador
				--Json Para el Objeto Remolque
				,JSON_QUERY((SELECT Remolques.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Remolque
				--Json Para el Objeto Anden
				,JSON_QUERY((SELECT Andenes.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Anden
				--Json Para el Objeto Ruta
				,JSON_QUERY((SELECT Rutas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ruta';
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Despachos.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Despachos.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo FolioDespacho
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'FolioDespacho')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Despachos.FolioDespacho) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Origen
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Origen')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Despachos.Origen) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Destino
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Destino')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Despachos.Destino) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo EstatusId
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'EstatusId')
			BEGIN
				SET @condicion = @condicion + 'Despachos.EstatusId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			Id bigint NOT NULL,
			FolioDespacho varchar(20) NOT NULL,
			Borrador bit NULL,
			Origen varchar(500) NULL,
			Destino varchar(500) NULL,
			VehiculoId bigint NULL,
			VehiculoTercero varchar(3000) NULL,
			RemolqueId bigint NULL,
			OperadorId bigint NULL,
			Custodia bit NULL,
			Auxiliares varchar(max) NULL,
			Peligroso bit NULL,
			RutaId bigint NULL,
			ServiciosAdicionales varchar(max) NULL,
			AndenId bigint NULL,
			EstatusId bigint NULL,
			Usuario varchar(150) NULL,
			Eliminado bit NULL,
			FechaCreacion datetime NULL,
			Trail varchar(max) NULL,
			OcupacionEfectiva varchar(20) NULL,
			TiempoEntrega varchar(30) NULL,
			Validador varchar(500) NULL,
			EncuestaOperadorPickup int NULL,
			OperadorPickupId bigint NULL,
			Vehiculo [nvarchar](max) NULL,
			Operador [nvarchar](max) NULL,
			Remolque [nvarchar](max) NULL,
			Anden [nvarchar](max) NULL,
			Ruta [nvarchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
				SELECT 
				   [Despachos].Id
				  ,[Despachos].FolioDespacho
				  ,[Despachos].Borrador
				  ,[Despachos].Origen
				  ,[Despachos].Destino
				  ,[Despachos].VehiculoId
				  ,[Despachos].VehiculoTercero
				  ,[Despachos].RemolqueId
				  ,[Despachos].OperadorId
				  ,[Despachos].Custodia
				  ,[Despachos].Auxiliares
				  ,[Despachos].Peligroso
				  ,[Despachos].RutaId
				  ,[Despachos].ServiciosAdicionales
				  ,[Despachos].AndenId
				  ,[Despachos].EstatusId
				  ,[Despachos].Usuario
				  ,[Despachos].Eliminado
				  ,[Despachos].FechaCreacion
				  ,[Despachos].Trail
				  ,[Despachos].OcupacionEfectiva
				  ,[Despachos].TiempoEntrega
				  ,[Despachos].Validador
				  ,[Despachos].EncuestaOperadorPickup
				  ,[Despachos].OperadorPickupId
					---------------------------------------------------------------------------------
					'+ @camposObjetos + '
					----------------------------------------------------------------------------------
					From [Despachos].[Despachos] Despachos				
					--Definir LEFT JOIN para traer el Objeto Vehiculo
					LEFT JOIN Vehiculos.Vehiculos Vehiculos ON Vehiculos.Id = Despachos.VehiculoId
					--Definir LEFT JOIN para traer el Objeto Operador
					LEFT JOIN Operadores.Colaboradores Operadores ON Operadores.Id = Despachos.OperadorId
					--Definir LEFT JOIN para traer el Objeto Remolque
					LEFT JOIN Remolques.Remolques Remolques ON Remolques.Id = Despachos.RemolqueId
					--Definir LEFT JOIN para traer el Objeto Anden
					LEFT JOIN Despachos.Andenes Andenes ON Andenes.Id = Despachos.AndenId
					--Definir LEFT JOIN para traer el Objeto Ruta
					LEFT JOIN Operadores.Rutas Rutas ON Rutas.Id = Despachos.RutaId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			   Id
			  ,FolioDespacho
			  ,Borrador
			  ,Origen
			  ,Destino
			  ,VehiculoId
			  ,VehiculoTercero
			  ,RemolqueId
			  ,OperadorId
			  ,Custodia
			  ,Auxiliares
			  ,Peligroso
			  ,RutaId
			  ,ServiciosAdicionales
			  ,AndenId
			  ,EstatusId
			  ,Usuario
			  ,Eliminado
			  ,FechaCreacion
			  ,Trail
			  ,OcupacionEfectiva
			  ,TiempoEntrega
			  ,Validador
			  ,EncuestaOperadorPickup
			  ,OperadorPickupId
			  ,Vehiculo
			  ,Operador
			  ,Remolque
			  ,Anden
			  ,Ruta
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[Despachos] Despachos ' + @condicion;
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
