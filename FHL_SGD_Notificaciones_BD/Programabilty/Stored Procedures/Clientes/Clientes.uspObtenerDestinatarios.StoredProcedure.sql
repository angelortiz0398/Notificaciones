USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerDestinatarios]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Hecho por: Erick Dominguez
-- Enero 2024
CREATE procedure [Clientes].[uspObtenerDestinatarios]
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
			SET @pageSize = (SELECT MAX(Id) FROM [Clientes].[Destinatarios]);
		END;
		PRINT @busqueda;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Destinatarios.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Destinatarios.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Razon Social
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'RazonSocial')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Destinatarios.RazonSocial) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo RFC
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'RFC')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Destinatarios.RFC) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Tipo Tarifa
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ClienteId')
			BEGIN
				SET @condicion = @condicion + 'Destinatarios.ClienteId = '+ CAST(@busqueda AS nvarchar(20)) + ' OR ';
			END		
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
			[Id] [bigint] NULL,
			[ClienteId] [bigint] NULL,
			[RazonSocial] [varchar](500) NULL,
			[RFC] [varchar](14) NULL,
			[AxaptaId] [varchar](50) NULL,
			[Referencia] [varchar](500) NULL,
			[Calle] [varchar](500) NULL,
			[NumeroExterior] [varchar](20) NULL,
			[NumeroInterior] [varchar](20) NULL,
			[Colonia] [varchar](500) NULL,
			[Localidad] [varchar](500) NULL,
			[Municipio] [varchar](500) NULL,
			[Estado] [varchar](500) NULL,
			[Pais] [varchar](150) NULL,
			[CodigoPostal] [int] NULL,
			[Coordenadas] [varchar](300) NULL,
			[RecepcionCita] [bit] NULL,
			[VentanaAtencion] [varchar](1500) NULL,
			[RestriccionCirculacion] [varchar](500) NULL,
			[HabilidadVehiculo] [varchar](2000) NULL,
			[DocumentoVehiculo] [varchar](2000) NULL,
			[HabilidadOperador] [varchar](2000) NULL,
			[DocumentoOperador] [varchar](2000) NULL,
			[HabilidadAuxiliar] [varchar](2000) NULL,
			[DocumentoAuxiliar] [varchar](2000) NULL,
			[EvidenciaSalida] [varchar](2000) NULL,
			[EvidenciaLlegada] [varchar](2000) NULL,
			[Sellos] [bit] NULL,
			[Checklist] [varchar](2000) NULL,
			[Contacto] [varchar](2000) NULL,
			[Geolocalizacion] [varchar](2000) NULL,
			[TiempoParado] [int] NULL,
			[Usuario] [varchar](150) NULL,
			[Eliminado] [bit] NULL,
			[FechaCreacion] [datetime] NULL,
			[Trail] [varchar](max) NULL,
			Cliente [nvarchar](max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT Destinatarios.[Id]
				  ,Destinatarios.[ClienteId]
				  ,Destinatarios.[RazonSocial]
				  ,Destinatarios.[RFC]
				  ,Destinatarios.[AxaptaId]
				  ,Destinatarios.[Referencia]
				  ,Destinatarios.[Calle]
				  ,Destinatarios.[NumeroExterior]
				  ,Destinatarios.[NumeroInterior]
				  ,Destinatarios.[Colonia]
				  ,Destinatarios.[Localidad]
				  ,Destinatarios.[Municipio]
				  ,Destinatarios.[Estado]
				  ,Destinatarios.[Pais]
				  ,Destinatarios.[CodigoPostal]
				  ,Destinatarios.[Coordenadas]
				  ,Destinatarios.[RecepcionCita]
				  ,Destinatarios.[VentanaAtencion]
				  ,Destinatarios.[RestriccionCirculacion]
				  ,Destinatarios.[HabilidadVehiculo]
				  ,Destinatarios.[DocumentoVehiculo]
				  ,Destinatarios.[HabilidadOperador]
				  ,Destinatarios.[DocumentoOperador]
				  ,Destinatarios.[HabilidadAuxiliar]
				  ,Destinatarios.[DocumentoAuxiliar]
				  ,Destinatarios.[EvidenciaSalida]
				  ,Destinatarios.[EvidenciaLlegada]
				  ,Destinatarios.[Sellos]
				  ,Destinatarios.[Checklist]
				  ,Destinatarios.[Contacto]
				  ,Destinatarios.[Geolocalizacion]
				  ,Destinatarios.[TiempoParado]
				  ,Destinatarios.[Usuario]
				  ,Destinatarios.[Eliminado]
				  ,Destinatarios.[FechaCreacion]
				  ,Destinatarios.[Trail]
				  ,JSON_QUERY((SELECT Cliente.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cliente
			  FROM [Clientes].[Destinatarios] Destinatarios
				LEFT JOIN Clientes.Clientes Cliente ON Cliente.Id = Destinatarios.ClienteId
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
				 PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
			   [Id]
			  ,[ClienteId]
			  ,[RazonSocial]
			  ,[RFC]
			  ,[AxaptaId]
			  ,[Referencia]
			  ,[Calle]
			  ,[NumeroExterior]
			  ,[NumeroInterior]
			  ,[Colonia]
			  ,[Localidad]
			  ,[Municipio]
			  ,[Estado]
			  ,[Pais]
			  ,[CodigoPostal]
			  ,[Coordenadas]
			  ,[RecepcionCita]
			  ,[VentanaAtencion]
			  ,[RestriccionCirculacion]
			  ,[HabilidadVehiculo]
			  ,[DocumentoVehiculo]
			  ,[HabilidadOperador]
			  ,[DocumentoOperador]
			  ,[HabilidadAuxiliar]
			  ,[DocumentoAuxiliar]
			  ,[EvidenciaSalida]
			  ,[EvidenciaLlegada]
			  ,[Sellos]
			  ,[Checklist]
			  ,[Contacto]
			  ,[Geolocalizacion]
			  ,[TiempoParado]
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
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Clientes].[Destinatarios] Destinatarios ' + @condicion;
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
