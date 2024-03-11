USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerVisores]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Omar Leyva
-- Create date: Enero 2024
-- Description:	Obtiene los registros de la tabla de Visores
-- =============================================
CREATE procedure [Despachos].[uspObtenerVisores]
	@pageIndex         int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		   int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		   varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		   nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				   bigint = 0,			-- Parametro para buscar por un Id
	@Autocomplete      bit = 0,              -- Parametro para obtener solo algunos campos de visores
	@Ticket        varchar(100)      = ''
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM Visores);
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = 'WHERE Visores.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Visores.Id = ' + CAST(@Id AS nvarchar(20));
		END

		--Si llega en el parametro @Manifiesto un manifiesto para filtras por maniefiesto 
		IF @Ticket IS NOT NULL  
		BEGIN 
			SET @condicion = @condicion + ' AND Visores.Ticket = ' + @Ticket;
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
			-- Si se quiere buscar por el campo NombrCliente
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Cliente')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Visores.Cliente) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
           -- Si se quiere buscar por el campo Manifiesto
			IF EXISTS (SELECT 1 FROM #FiltrosTemporal WHERE Campo = 'Manifiesto')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Visores.Manifiesto) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
            -- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		if (@Autocomplete = 1)
			BEGIN
			
			DECLARE @TablaTemporalAuto TABLE(
			Id BIGINT,
			ManifiestoId BIGINT,
			Manifiesto VARCHAR(20),
			Placa VARCHAR(50),
			Economico VARCHAR(50)
			);

			insert into @TablaTemporalAuto(
			Id,
			ManifiestoId,
			Manifiesto,
			Placa,
			Economico
			)
			select 
			Id,
			ManifiestoId,
			Manifiesto,
			Placa,
			Economico
			FROM Despachos.Visores
			GOTO SALIDA;
			END
	
		-- Crecion de la tabla temporal donde se almacenaran los registros
		DECLARE @TablaTemporal TABLE(
	Id bigint  NOT NULL,
	Manifiesto varchar(20) NOT NULL,
	ClienteId bigint NULL,
	Cliente varchar(300) NULL,
	Custodia bit NULL,
	Operador varchar(350) NULL,
	Vehiculo varchar(150) NOT NULL,
	Placa varchar(50) NOT NULL,
	Economico varchar(150) NOT NULL,
	Origen varchar(350) NOT NULL,
	Destino varchar(350) NOT NULL,
	VentanaAtencionInicio varchar(100) NOT NULL,
	VentanaAtencionFin varchar(100) NOT NULL,
	Estatus int NULL,
	ManifiestoId bigint NULL,
	Ticket varchar(20) NULL,
	TiempoRestante int NULL,
	UbicacionActual varchar(1500) NULL,
	TipoEntregaId bigint NULL,
	PrioridadId bigint NULL,
	Reintentos int NULL,
	Restantes int NULL,
	Ubicacion varchar(500) NULL,
	DiasLaborados int NULL,
	UltimoServicio datetime NULL,
	DiasTranscurridos int NULL,
	HorasDetenido varchar(20) NULL,
	CostoFlete numeric(18, 2) NULL,
	GastosOperativos numeric(18, 2) NULL,
	GastosIndirectos numeric(18, 2) NULL,
	GastosNoJustificados numeric(18, 2) NULL,
	UltimoMovimientoGPS datetime NULL,
	DistanciaRuta numeric(18, 2) NULL,
	DistanciaRealizada numeric(18, 2) NULL,
	FechaCargaEstimada datetime NULL,
	FechaCarga datetime NULL,
	FechaSalidaEstimada datetime NULL,
	FechaSalida datetime NULL,
	FechaPromesaLlegada datetime NULL,
	FechaLlegada datetime NULL,
	FechaPromesaRetorno datetime NULL,
	FechaRetorno datetime NULL,
	FechaCreacionViaje datetime NULL,
	EtaDestino datetime NULL,
	EtaRetorno datetime NULL,
	Usuario varchar(150) NULL,
	Eliminado bit NULL,
	FechaCreacion datetime NULL,
	Trail varchar(max) NULL
    );
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
	   SELECT Visores.[Id]
      ,Visores.[Manifiesto]
      ,Visores.[ClienteId]
      ,Visores.[Cliente]
      ,Visores.[Custodia]
      ,Visores.[Operador]
      ,Visores.[Vehiculo]
      ,Visores.[Placa]
      ,Visores.[Economico]
      ,Visores.[Origen]
      ,Visores.[Destino]
      ,Visores.[VentanaAtencionInicio]
      ,Visores.[VentanaAtencionFin]
      ,Visores.[Estatus]
      ,Visores.[ManifiestoId]
      ,Visores.[Ticket]
      ,Visores.[TiempoRestante]
      ,Visores.[UbicacionActual]
      ,Visores.[TipoEntregaId]
      ,Visores.[PrioridadId]
      ,Visores.[Reintentos]
      ,Visores.[Restantes]
      ,Visores.[Ubicacion]
      ,Visores.[DiasLaborados]
      ,Visores.[UltimoServicio]
      ,Visores.[DiasTranscurridos]
      ,Visores.[HorasDetenido]
      ,Visores.[CostoFlete]
      ,Visores.[GastosOperativos]
      ,Visores.[GastosIndirectos]
      ,Visores.[GastosNoJustificados]
      ,Visores.[UltimoMovimientoGPS]
      ,Visores.[DistanciaRuta]
      ,Visores.[DistanciaRealizada]
      ,Visores.[FechaCargaEstimada]
      ,Visores.[FechaCarga]
      ,Visores.[FechaSalidaEstimada]
      ,Visores.[FechaSalida]
      ,Visores.[FechaPromesaLlegada]
      ,Visores.[FechaLlegada]
      ,Visores.[FechaPromesaRetorno]
      ,Visores.[FechaRetorno]
      ,Visores.[FechaCreacionViaje]
      ,Visores.[EtaDestino]
      ,Visores.[EtaRetorno]
      ,Visores.[Usuario]
      ,Visores.[Eliminado]
      ,Visores.[FechaCreacion]
      ,Visores.[Trail]                 
                    
                FROM [Despachos].[Visores] Visores
                                                                  
                    ------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY';
		-- Se inserta en la tabla temporal los registros
		INSERT INTO @TablaTemporal (
	  [Id]
      ,[Manifiesto]
      ,[ClienteId]
      ,[Cliente]
      ,[Custodia]
      ,[Operador]
      ,[Vehiculo]
      ,[Placa]
      ,[Economico]
      ,[Origen]
      ,[Destino]
      ,[VentanaAtencionInicio]
      ,[VentanaAtencionFin]
      ,[Estatus]
      ,[ManifiestoId]
      ,[Ticket]
      ,[TiempoRestante]
      ,[UbicacionActual]
      ,[TipoEntregaId]
      ,[PrioridadId]
      ,[Reintentos]
      ,[Restantes]
      ,[Ubicacion]
      ,[DiasLaborados]
      ,[UltimoServicio]
      ,[DiasTranscurridos]
      ,[HorasDetenido]
      ,[CostoFlete]
      ,[GastosOperativos]
      ,[GastosIndirectos]
      ,[GastosNoJustificados]
      ,[UltimoMovimientoGPS]
      ,[DistanciaRuta]
      ,[DistanciaRealizada]
      ,[FechaCargaEstimada]
      ,[FechaCarga]
      ,[FechaSalidaEstimada]
      ,[FechaSalida]
      ,[FechaPromesaLlegada]
      ,[FechaLlegada]
      ,[FechaPromesaRetorno]
      ,[FechaRetorno]
      ,[FechaCreacionViaje]
      ,[EtaDestino]
      ,[EtaRetorno]
      ,[Usuario]
      ,[Eliminado]
      ,[FechaCreacion]
      ,[Trail]
                )
		EXEC sp_executesql @return_query

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Despachos].[Visores] Visores ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		DECLARE @TotalRows TABLE(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO @TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;


		
		-- Retorna TotalRows y el JsonSalida
		SELECT * FROM @TablaTemporal
		SELECT TotalRows FROM @TotalRows AS TotalROws;
		
		SALIDA: 
		If(@Autocomplete = 1)
		BEGIN
			SELECT * FROM @TablaTemporalAuto
		END
		
end
GO
