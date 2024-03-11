USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerRegistroDispersiones]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Obtiene los registros de la tabla de RegistrosDispersiones
-- =============================================
CREATE procedure [Despachos].[uspObtenerRegistroDispersiones]
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
			SET @pageSize = (SELECT MAX(Id) FROM RegistrosDispersiones);
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE RegistrosDispersiones.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND RegistrosDispersiones.Id = ' + CAST(@Id AS nvarchar(20));
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
			-- Si se quiere buscar por el campo Monto
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Monto')
			BEGIN
				SET @condicion = @condicion + 'LOWER(RegistrosDispersiones.Monto) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo DespachoId
					IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'DespachoId')
			BEGIN
				SET @condicion = @condicion + 'RegistrosDispersiones.DespachoId = '+ CAST(@busqueda AS nvarchar(255)) + ' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
	Id bigint NOT NULL,
	DespachoId bigint NOT NULL,
	ColaboradorId bigint NOT NULL,
	MonedaIdMonto int NOT NULL,
	Monto numeric(18, 2) NULL,
	TipoGastoId bigint NULL,
	MetodoId int NULL,
	GastoOperativoId int NULL,
	ColaboradorAutorizadoId bigint NULL,
	Usuario varchar(150) NULL,
	Eliminado bit NULL,
	FechaCreacion datetime NULL,
	Trail varchar(max) NULL,
    Despacho nvarchar(max)NULL,
    Colaborador nvarchar(max)NULL,
    TipoGasto nvarchar(max)NULL,
	GastoOperativo  nvarchar(max)NULL,
	ColaboradorAutorizado nvarchar(max)NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			 SELECT RegistrosDispersiones.[Id]
                    ,RegistrosDispersiones.[DespachoId]
                    ,RegistrosDispersiones.[ColaboradorId]
					,RegistrosDispersiones.[MonedaIdMonto]
                    ,RegistrosDispersiones.[Monto]
                    ,RegistrosDispersiones.[TipoGastoId]
                    ,RegistrosDispersiones.[MetodoId]
                    ,RegistrosDispersiones.[GastoOperativoId]
                    ,RegistrosDispersiones.[ColaboradorAutorizadoId]
                    ,RegistrosDispersiones.[Usuario]
                    ,RegistrosDispersiones.[Eliminado]
                    ,RegistrosDispersiones.[FechaCreacion]
                    ,RegistrosDispersiones.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Visores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Despacho
                    ,JSON_QUERY((SELECT Colaborador.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador
                    ,JSON_QUERY((SELECT TipoGasto.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoGasto
                    ,JSON_QUERY((SELECT ColaboradorAutorizado.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ColaboradorAutorizado

                FROM [Despachos].[RegistrosDispersiones] RegistrosDispersiones
                        LEFT JOIN Despachos.Visores Visores ON Visores.ManifiestoId = RegistrosDispersiones.DespachoId
                        LEFT JOIN Operadores.Colaboradores Colaborador ON Colaborador.Id = RegistrosDispersiones.ColaboradorId
                        LEFT JOIN Despachos.TipoGastos TipoGasto ON TipoGasto.Id = RegistrosDispersiones.TipoGastoId
                        LEFT JOIN Operadores.Colaboradores ColaboradorAutorizado ON ColaboradorAutorizado.Id = RegistrosDispersiones.ColaboradorAutorizadoId

                        
                                            ------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
	  [Id]
      ,[DespachoId]
      ,[ColaboradorId]
      ,[MonedaIdMonto]
      ,[Monto]
      ,[TipoGastoId]
      ,[MetodoId]
      ,[GastoOperativoId]
      ,[ColaboradorAutorizadoId]
      ,[Usuario]
      ,[Eliminado]
      ,[FechaCreacion]
      ,[Trail]
      ,Despacho
      ,Colaborador
      ,TipoGasto
	  ,ColaboradorAutorizado
		)
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[RegistrosDispersiones] RegistrosDispersiones ' + @condicion;
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
