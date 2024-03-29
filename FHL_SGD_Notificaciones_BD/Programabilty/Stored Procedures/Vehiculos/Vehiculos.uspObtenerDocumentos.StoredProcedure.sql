USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerDocumentos]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspObtenerDocumentos] 
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0			-- Parametro para buscar por un Id
AS
BEGIN
	--No regresar dato de filas afectadas
	SET NOCOUNT ON;

	--Si la cantidad de registros que quiere es 0,  entonces traera todos los registros
	IF @pageSize = 0
	Begin
		SET @pageSize = (SELECT MAX(Id) FROM [Vehiculos].[Documentos]);
	END;

	/****** Zona de filtro ******/
	--Variable que concatena la condicion general y las condiciones de los filtros
	DECLARE @condicion nvarchar(max) = 'WHERE Documentos.Eliminado = 1';

	--Si llega en el parametro un Id por el que buscar
	IF @Id >0
	BEGIN 
		SET @condicion = @condicion + 'AND Documentos.Id = ' + CAST(@Id AS NVARCHAR(20));
	END

	--Crea una tabla temporal para almacenar los filtros
	CREATE TABLE #FiltrosTemporal (
		Campo VARCHAR(20) NOT NULL
	);

	IF (@filtros <> '')
	BEGIN
		--Inserta en la tabla temporal los campos por los que se va a filtrar
		INSERT INTO #FiltrosTemporal (Campo) SELECT * FROM OPENJSON (@filtros)
		WITH
		(
		Campo VARCHAR(20)
		)

		--Se agrega ' AND(' cuando exista mas de un filtro po el que buscar
		IF  (SELECT COUNT(Campo) FROM #FiltrosTemporal) > 0
		BEGIN
			SET @condicion = @condicion + ' AND (';
		END

		--Si se quiere buscar por el campo nombre
		IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Nombre')
		BEGIN
			SET @condicion = @condicion + 'Lower(Documentos.Nombre) LIKE ''%' + LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR  ';
		END
		-- Si se quiere buscar por el campo VehiculoId
		IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'VehiculoId')
		BEGIN
			SET @condicion = @condicion + 'Documentos.VehiculoId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
		END
		----Si se quiere buscar por el campo  ClaveInterna
		--IF EXISTS(SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'ClaveUN')
		--BEGIN
		--	SET @condicion = @condicion + 'Lower(Checkslist.ClaveUN) Like ''%' + LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
		--END

		--Al final se elimina 'OR' sobrante
		SET @condicion = SUBSTRING(@condicion,1, LEN(@condicion)- 3);
		--Se le concatena al final in ')'
		SET @condicion = @condicion + ')';
	END

	--Creacion de la tabla temporal deonde se almacenaran los registros
	CREATE TABLE #TablaTemporal(
		[Id] [BIGINT]NULL,
		[TiposDocumentosId] [BIGINT]NULL,
		[VehiculoId] [BIGINT]NULL,
		[Nombre] [VARCHAR](150)Null,
		[Emitido] [VARCHAR](300)Null,
		[FechaVencimiento] [DATETIME]Null,
		[RutaArchivo] [VARCHAR](500)Null,
		[Usuario] [VARCHAR](150)Null,
		[Eliminado] [BIT]Null,
		[FechaCreacion] [DATETIME]Null,
		[Trail] [VARCHAR](MAX)Null,
		[TiposDocumentos] [VARCHAR](MAX)Null
		--[Vehiculo] [VARCHAR](MAX)Null
		);

		DECLARE @return_query NVARCHAR(MAX);

		SET @return_query = '
			SELECT 
			Documentos.[Id],
			Documentos.[TiposDocumentosId],
			Documentos.[VehiculoId],
			Documentos.[Nombre],
			Documentos.[Emitido],
			Documentos.[FechaVencimiento],
			Documentos.[RutaArchivo],
			Documentos.[Usuario],
			Documentos.[Eliminado],
			Documentos.[FechaCreacion],
			Documentos.[Trail]

			--Tablas 
			,JSON_Query((SELECT TipoDoc.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TiposDocumentos
			--,JSON_Query((SELECT Vehic.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculo

			FROM [Vehiculos].[Documentos] Documentos
			LEFT JOIN GestorDocumentos.TiposDocumentos TipoDoc on TipoDoc.Id = Documentos.TiposDocumentosId
			--LEFT JOIN Vehiculos.Vehiculos Vehic on Vehic.Id = Documentos.VehiculoId
					'+ @condicion +'
					ORDER BY Id ASC
					OFFSET ('+ CAST(@pageIndex AS VARCHAR(10)) +'-1) * ' + CAST (@pageIndex AS VARCHAR(10)) + ' ROWS
					FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';


print @return_query

--Se inserta en la tabla temporal los registros 
			INSERT INTO #TablaTemporal(
				[Id],
				[TiposDocumentosId],
				[VehiculoId],
				[Nombre],
				[Emitido],
				[FechaVencimiento],
				[RutaArchivo],
				[Usuario],
				[Eliminado],
				[FechaCreacion],
				[Trail],
				TiposDocumentos
				--Vehiculo
			)

			EXEC sp_executesql @return_query


			----Obtiene la informacion de los registros y la convierte n un formato JSON
			DECLARE @sqlQuery NVARCHAR(MAX);
			--construye la consulta sin la paginacion y solo con los filtros
			SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Vehiculos].[Documentos] Documentos ' + @condicion;
			--delclara una variable para almacenar la cantidad de registros resultantes
			CREATE TABLE #TotalRows (
			TotalRows int null
			)
			--ejecuta la consulta dinamicamente y almacena el resultado en @TotalRows
			INSERT INTO #TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna TotalRows y los registros
		SELECT * FROM #TablaTemporal
		SELECT TotalRows FROM #TotalRows

			 --Eliminar las tablas temporales

			 DROP TABLE #TablaTemporal;
			 DROP TABLE #FiltrosTemporal;
			 DROP TABLE #TotalRows;

END
GO
