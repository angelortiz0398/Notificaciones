USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerConsideracionesViajes]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Diciembre 2023
CREATE procedure [Clientes].[uspObtenerConsideracionesViajes]
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
			SET @pageSize = (SELECT MAX(Id) FROM [Clientes].[ConsideracionesViajes]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE ConsideracionesViajes.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND ConsideracionesViajes.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Tipo Tarifa
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ClienteId')
			BEGIN
				SET @condicion = @condicion + 'ConsideracionesViajes.ClienteId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		

			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			[Id] [bigint] NULL,
			[ClienteId] [bigint] NOT NULL,
			[HabilidadVehiculo] [varchar](2000) NULL,
			[DocumentoVehiculo] [varchar](2000) NULL,
			[HabilidadDeColaborador] [varchar](2000) NULL,
			[DocumentoOperador] [varchar](2000) NULL,
			[HabilidadAuxiliar] [varchar](2000) NULL,
			[DocumentoAuxiliar] [varchar](2000) NULL,
			[EvidenciaCarga] [varchar](2000) NULL,
			[EvidenciaDescarga] [varchar](2000) NULL,
			[Checklist] [varchar](2000) NULL,
			[Contacto] [varchar](2000) NULL,
			[Geolocalizacion] [varchar](2000) NULL,
			[TiempoSalidaPrevio] [int] NULL,
			[PresenciaOperador] [int] NULL,
			[HorasEmbarque] [int] NULL,
			[Usuario] [varchar](150) NULL,
			[Eliminado] [bit] NULL,
			[FechaCreacion] [datetime] NULL,
			[Trail] [varchar](max) NULL,
			Cliente [nvarchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT ConsideracionesViajes.[Id]
				  ,ConsideracionesViajes.[ClienteId]
				  ,ConsideracionesViajes.[HabilidadVehiculo]
				  ,ConsideracionesViajes.[DocumentoVehiculo]
				  ,ConsideracionesViajes.[HabilidadDeColaborador]
				  ,ConsideracionesViajes.[DocumentoOperador]
				  ,ConsideracionesViajes.[HabilidadAuxiliar]
				  ,ConsideracionesViajes.[DocumentoAuxiliar]
				  ,ConsideracionesViajes.[EvidenciaCarga]
				  ,ConsideracionesViajes.[EvidenciaDescarga]
				  ,ConsideracionesViajes.[Checklist]
				  ,ConsideracionesViajes.[Contacto]
				  ,ConsideracionesViajes.[Geolocalizacion]
				  ,ConsideracionesViajes.[TiempoSalidaPrevio]
				  ,ConsideracionesViajes.[PresenciaOperador]
				  ,ConsideracionesViajes.[HorasEmbarque]
				  ,ConsideracionesViajes.[Usuario]
				  ,ConsideracionesViajes.[Eliminado]
				  ,ConsideracionesViajes.[FechaCreacion]
				  ,ConsideracionesViajes.[Trail]	
				  ,JSON_QUERY((SELECT Cliente.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
			  FROM [Clientes].[ConsideracionesViajes] ConsideracionesViajes
			  LEFT JOIN Clientes.Clientes Cliente ON Cliente.Id = ConsideracionesViajes.ClienteId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				--PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			   [Id]
		  ,[ClienteId]
		  ,[HabilidadVehiculo]
		  ,[DocumentoVehiculo]
		  ,[HabilidadDeColaborador]
		  ,[DocumentoOperador]
		  ,[HabilidadAuxiliar]
		  ,[DocumentoAuxiliar]
		  ,[EvidenciaCarga]
		  ,[EvidenciaDescarga]
		  ,[Checklist]
		  ,[Contacto]
		  ,[Geolocalizacion]
		  ,[TiempoSalidaPrevio]
		  ,[PresenciaOperador]
		  ,[HorasEmbarque]
		  ,[Usuario]
		  ,[Eliminado]
		  ,[FechaCreacion]
		  ,[Trail]
		  ,Cliente
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Clientes].[ConsideracionesViajes] ConsideracionesViajes ' + @condicion;
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
