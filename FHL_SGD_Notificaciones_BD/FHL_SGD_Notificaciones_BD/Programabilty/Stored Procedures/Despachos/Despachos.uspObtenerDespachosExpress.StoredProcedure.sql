USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerDespachosExpress]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Obtiene los registros de la tabla de DespachosExpress
-- =============================================
CREATE procedure [Despachos].[uspObtenerDespachosExpress]
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
			SET @pageSize = (SELECT MAX(Id) FROM DespachosExpress);
		END;

		/** Zona de filtros **/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE DespachosExpress.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND DespachosExpress.Id = ' + CAST(@Id AS nvarchar(20));
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
		
			-- Al final se elimina 'OR ' sobrante
			--SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		CREATE TABLE #TablaTemporal(
	Id bigint NOT NULL,
	VehiculoId bigint NOT NULL,
	ColaboradorId bigint NOT NULL,
	Auxiliares varchar(5000) NULL,
	FecInicial datetime NULL,
	FecFinal datetime NULL,
	OrigenId bigint NULL,
	DestinoId bigint NULL,
	Referencia varchar(1500) NULL,
	Efectividad int NULL,
	Distancia int NULL,
	Usuario varchar(150) NULL,
	Eliminado bit NULL,
	FechaCreacion datetime NULL,
	Trail varchar(max) NULL,
	Vehiculo nvarchar(max) NULL,
	Colaborador nvarchar(max) NULL,	
	Destino nvarchar(max)NULL,
	Origen nvarchar(max)NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			 SELECT  
			 		 DespachosExpress.[Id]
					,DespachosExpress.[VehiculoId]
					,DespachosExpress.[ColaboradorId]
					,DespachosExpress.[Auxiliares]
					,DespachosExpress.[FecInicial]
					,DespachosExpress.[FecFinal]
					,DespachosExpress.[OrigenId]
					,DespachosExpress.[DestinoId]
					,DespachosExpress.[Referencia]
					,DespachosExpress.[Efectividad]
					,DespachosExpress.[Distancia]
					,DespachosExpress.[Usuario]
					,DespachosExpress.[Eliminado]
					,DespachosExpress.[FechaCreacion]
					,DespachosExpress.[Trail]

                    --Tablas relacionadas con Sellos
                    ,JSON_QUERY((SELECT Ticket.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ticket
                    
                FROM  Despachos.DespachosExpress DespachosExpress
                        LEFT JOIN Despachos.Tickets Ticket ON Ticket.Id = DespachosExpress.TicketId
						----Poner joins
                                            ------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		-- Se inserta en la tabla temporal los registros
		INSERT INTO #TablaTemporal (
								 [VehiculoId]
								,[ColaboradorId]
								,[Auxiliares]
								,[FecInicial]
								,[FecFinal]
								,[OrigenId]
								,[DestinoId]
								,[Referencia]
								,[Efectividad]
								,[Distancia]
								,[Usuario]
								,[Eliminado]
								,[FechaCreacion]
								,[Trail]
								,Vehiculo
								,Colaborador
								,Destino
								,Origen
      							   )
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[DespachosExpress] DespachosExpress ' + @condicion;
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
