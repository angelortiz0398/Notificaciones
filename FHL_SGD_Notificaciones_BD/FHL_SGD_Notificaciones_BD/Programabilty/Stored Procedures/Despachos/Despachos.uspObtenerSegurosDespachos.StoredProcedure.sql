USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerSegurosDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Dominguez
-- Create date: 08/02/2024
-- Description:	Obtención de los registros
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerSegurosDespachos]

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
		SET @pageSize = (SELECT MAX(Id) FROM [Despachos].[SegurosDespachos]);
	END;

	/****** Zona de filtro ******/
	--Variable que concatena la condicion general y las condiciones de los filtros
	DECLARE @condicion nvarchar(max) = 'WHERE SegurosDespachos.Eliminado = 1';

	--Si llega en el parametro un Id por el que buscar
	IF @Id >0
	BEGIN 
		SET @condicion = @condicion + 'AND SegurosDespachos.Id = ' + CAST(@Id AS NVARCHAR(20));
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

		--Al final se elimina 'OR' sobrante
		SET @condicion = SUBSTRING(@condicion,1, LEN(@condicion)- 3);
		--Se le concatena al final in ')'
		SET @condicion = @condicion + ')';
	END

	--Creacion de la tabla temporal deonde se almacenaran los registros
	CREATE TABLE #TablaTemporal(
			[Id] [bigint] NULL,
			[DespachoId] [bigint]  NULL,
			[Folio] [bigint]  NULL,
			[ClienteId] [bigint] NULL,
			[NumeroControl] [int] NULL,
			[DescripcionMercancia] [varchar](max) NULL,
			[Cantidad] [int] NULL,
			[ValorMercancia] [numeric](18, 2) NULL,
			[SumaAsegurada] [numeric](18, 2) NULL,
			[TarifaPoliza] [numeric](18, 2) NULL,
			[DerechoPoliza] [numeric](18, 2) NULL,
			[TotalCobrar] [numeric](18, 2) NULL,
			[Origen] [varchar](500) NULL,
			[DestinoId] [bigint] NULL,
			[MedioTransporteId] [bigint] NULL,
			[MedidasSeguridad] [varchar](500) NULL,
			[FechaSalida] [datetime] NULL,
			[FechaLLegada] [datetime] NULL,
			[Contenido] [varchar](5000) NULL,
			[Usuario] [varchar](150) NULL,
			[Eliminado] [bit] NULL,
			[FechaCreacion] [datetime] NULL,
			[Trail] [varchar](max) NULL
			);

		DECLARE @return_query NVARCHAR(MAX);

		SET @return_query = '
			SELECT 
				SegurosDespachos.[Id]
				,SegurosDespachos.[DespachoId]
				,SegurosDespachos.[Folio]
				,SegurosDespachos.[ClienteId]
				,SegurosDespachos.[NumeroControl]
				,SegurosDespachos.[DescripcionMercancia]
				,SegurosDespachos.[Cantidad]
				,SegurosDespachos.[ValorMercancia]
				,SegurosDespachos.[SumaAsegurada]
				,SegurosDespachos.[TarifaPoliza]
				,SegurosDespachos.[DerechoPoliza]
				,SegurosDespachos.[TotalCobrar]
				,SegurosDespachos.[Origen]
				,SegurosDespachos.[DestinoId]
				,SegurosDespachos.[MedioTransporteId]
				,SegurosDespachos.[MedidasSeguridad]
				,SegurosDespachos.[FechaSalida]
				,SegurosDespachos.[FechaLLegada]
				,SegurosDespachos.[Contenido]
				,SegurosDespachos.[Usuario]
				,SegurosDespachos.[Eliminado]
				,SegurosDespachos.[FechaCreacion]
				,SegurosDespachos.[Trail]

				FROM [Despachos].[SegurosDespachos] SegurosDespachos 
					

					'+ @condicion +'
					ORDER BY Id DESC
					OFFSET ('+ CAST(@pageIndex AS VARCHAR(10)) +'-1) * ' + CAST (@pageIndex AS VARCHAR(10)) + ' ROWS
					FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';

--Se inserta en la tabla temporal los registros 
			INSERT INTO #TablaTemporal(
				[Id]
			  ,[DespachoId]
			  ,[Folio]
			  ,[ClienteId]
			  ,[NumeroControl]
			  ,[DescripcionMercancia]
			  ,[Cantidad]
			  ,[ValorMercancia]
			  ,[SumaAsegurada]
			  ,[TarifaPoliza]
			  ,[DerechoPoliza]
			  ,[TotalCobrar]
			  ,[Origen]
			  ,[DestinoId]
			  ,[MedioTransporteId]
			  ,[MedidasSeguridad]
			  ,[FechaSalida]
			  ,[FechaLLegada]
			  ,[Contenido]
			  ,[Usuario]
			  ,[Eliminado]
			  ,[FechaCreacion]
			  ,[Trail]
			)

			EXEC sp_executesql @return_query


			----Obtiene la informacion de los registros y la convierte n un formato JSON
			DECLARE @sqlQuery NVARCHAR(MAX);
			--construye la consulta sin la paginacion y solo con los filtros
			SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[SegurosDespachos] SegurosDespachos ' + @condicion;
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
