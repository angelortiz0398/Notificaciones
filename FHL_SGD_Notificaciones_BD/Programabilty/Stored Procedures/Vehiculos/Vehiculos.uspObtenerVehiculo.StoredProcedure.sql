USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerVehiculo]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspObtenerVehiculo]

    @pageIndex      int = 1,				-- Parametro que indica la pagina que estas buscando
	@pageSize		int = 10,			-- Parametro que indica cuantos registros quieres por pagina
	@busqueda		varchar(255) = '',	-- Parametro para la busqueda 
	@filtros		nvarchar(255) = null,-- Parametro donde se guardan los campos a los que se quieren filtrar	
	@Id				bigint = 0,			-- Parametro para buscar por un Id
	@AppMovil		bit = 0		      --Parametro para enviar solo los datos solicitados para la APP MOVIL
as
Begin
		--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		-- Variable para almacenar los campos que contengan un json y que se deserializaran
		DECLARE @camposObjetos nvarchar(max) = '';
		-- Si la cantidad de registros que quiere es 0, entonces traera todos los registros y sin objetos con json
		IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM [Vehiculos].[Vehiculos]);
			SET @camposObjetos = ',null
			,null
			,null
			,null
			,null
			,null
			,null
			,null
			,null
			,null
			';

				--SET @camposObjetos = ',JSON_QUERY((SELECT Marcas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Marca
				--,JSON_QUERY((SELECT Modelos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Modelo
				--,JSON_QUERY((SELECT Colores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Color
				--,JSON_QUERY((SELECT TiposCombustibles.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCombustible
				--,JSON_QUERY((SELECT Proveedores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Proveedor
				--,JSON_QUERY((SELECT Esquemas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Esquema
				--,JSON_QUERY((SELECT ProveedorSeguros.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ProveedorSeguro
				--,JSON_QUERY((SELECT Configuraciones.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Configuracion
				--,JSON_QUERY((SELECT VehiculosTipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Tipo
				--,JSON_QUERY((SELECT Colaboradores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador ';
		END;
		ELSE
		BEGIN 
			SET @camposObjetos = ',JSON_QUERY((SELECT Marcas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Marca
				,JSON_QUERY((SELECT Modelos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Modelo
				,JSON_QUERY((SELECT Colores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Color
				,JSON_QUERY((SELECT TiposCombustibles.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCombustible
				,JSON_QUERY((SELECT Proveedores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Proveedor
				,JSON_QUERY((SELECT Esquemas.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Esquema
				,JSON_QUERY((SELECT ProveedorSeguros.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ProveedorSeguro
				,JSON_QUERY((SELECT Configuraciones.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Configuracion
				,JSON_QUERY((SELECT VehiculosTipos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Tipo
				,JSON_QUERY((SELECT Colaboradores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador';
		END;

		/****** Zona de filtros ******/
		-- Variable que concatena la condición general y las condiciones de los filtros
		DECLARE @condicion nvarchar(max) = ' WHERE Vehiculos.Eliminado = 1';

		-- Si llega en el parametro un Id por el que buscar
		IF @Id > 0
		BEGIN
			SET @condicion = @condicion + ' AND Vehiculos.Id = ' + CAST(@Id AS nvarchar(20));
		END


		--Condicionante para enviar datos a la versión movil
		if (@AppMovil = 1)
			BEGIN		
				--Declaramos una tabla temporal para guardar los Id de vehiculos app
				DECLARE @TablaVehiculoList TABLE(Id bigint);

				-- Declarar una variable para almacenar la lista de vehículos
				DECLARE @VehicleList TABLE (Id bigint);

				-- Insertar los valores de la lista de vehículos en la tabla variable
				INSERT INTO @VehicleList (Id)
				SELECT value
				FROM OPENJSON(@filtros, '$.vehicleList');

				-- Insertar los valores de la tabla variable en la tabla temporal
				INSERT INTO @TablaVehiculoList (Id)
				SELECT Id
				FROM @VehicleList;


				--Tabla temporal para las propiedades necesarias en movil
				DECLARE @TablaTemporalMovil TABLE(
				Id bigint null,
				Placa varchar(50) NULL,
				Economico varchar(150) NULL,
				Vin varchar(50) NULL,
				Latitud numeric(18,6) NULL,
				Longitud numeric(18,6) NULL,
				Foto nvarchar(max) NULL
				);

				insert into @TablaTemporalMovil(
				Id,
				Placa,
				Economico,
				Vin,
				Latitud,
				Longitud
				--Foto
				)
				select 
				Vehiculo.Id,
				Vehiculo.Placa,
				Vehiculo.Economico,
				Vehiculo.Vin,
				Gps.Latitud,
				Gps.Longitud
				--Foto
				FROM Vehiculos.Vehiculos Vehiculo
				LEFT JOIN GPS.GPS Gps ON Gps.VehiculoId = Vehiculo.Id
				WHERE (
					(SELECT COUNT(*) FROM @TablaVehiculoList) > 0
					AND Vehiculo.Id IN (SELECT Id FROM @TablaVehiculoList)
				)
				OR (SELECT COUNT(*) FROM @TablaVehiculoList) = 0;

				GOTO SALIDA;
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
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'Placa')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Vehiculos.Placa) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo RFC
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'RFC')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Vehiculos.Economico) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Si se quiere buscar por el campo Identificacion
			IF EXISTS (SELECT 1 FROM @FiltrosTemporal WHERE Campo = 'VIN')
			BEGIN
				SET @condicion = @condicion + 'LOWER(Vehiculos.VIN) LIKE ''%'+ LOWER(LTRIM(RTRIM(CAST(@busqueda AS VARCHAR(255))))) + '%'' OR ';
			END
			-- Al final se elimina 'OR ' sobrante
			SET @condicion = SUBSTRING(@condicion, 1, LEN(@condicion) - 3);
			-- Se le concatena al final un ')'
			SET @condicion = @condicion + ')';
		END

		-- Crecion de la tabla temporal donde se almacenaran los registros
		DECLARE @TablaTemporal TABLE(
			Id bigint NULL,
			Placa varchar(50) NULL,
			Economico varchar(150) NULL,
			Vin varchar(50) NULL,
			MarcaId bigint NULL,
			ModeloId bigint NULL,
			Anio int NULL,
			ColorId bigint NULL,
			TipoCombustibleId bigint NULL,
			TanqueCombustible int NULL,
			RendimientoMixto numeric(18, 2) NULL,
			RendimientoUrbano numeric(18, 2) NULL,
			RendimientoSuburbano numeric(18, 2) NULL,
			CapacidadVolumen int NULL,
			CapacidadVolumenEfectivo int NULL,
			ProveedorId bigint NULL,
			EsquemaId bigint NULL,
			Factura varchar(150) NULL,
			FacturaCarrocero varchar(150) NULL,
			ProveedorSeguroId bigint NULL,
			PolizaSeguro varchar(50) NULL,
			Inciso int NULL,
			Prima numeric(18, 2) NULL,
			NumPermiso varchar(150) NULL,
			TipoPermiso varchar(50) NULL,
			ConfiguracionId bigint NULL,
			TipoId bigint NULL,
			ColaboradorId bigint NULL,
			Maniobras int NULL,
			Motor varchar(50) NULL,
			FactorCo2 numeric(18, 2) NULL,
			TagCaseta varchar(50) NULL,
			UltimoOdometro numeric(18, 2) NULL,
			Estado bit NULL,
			Usuario varchar(150) NULL,
			Eliminado bit NULL,
			FechaCreacion datetime NULL,
			Trail varchar(max) NULL,
			GrupoVehiculo varchar(3000) NULL,
			HabilidadVehiculos varchar(5000) NULL,
			RangoOperacion varchar(3000) NULL,
			Un varchar(5000) NULL,
			Marca nvarchar(max) NULL,
			Modelo nvarchar(max) NULL,
			Color nvarchar(max) NULL,
			TipoCombustible nvarchar(max) NULL,
			Proveedor nvarchar(max) NULL,
			Esquema nvarchar(max) NULL,
			ProveedorSeguro nvarchar(max) NULL,
			Configuracion nvarchar(max) NULL,
			Tipo nvarchar(max) NULL,
			Colaborador nvarchar(max) NULL,
			Latitud numeric(18,2) NULL,
			Longitud numeric(18,2) NULL,
			Foto nvarchar(max) NULL
			);
		DECLARE @return_query NVARCHAR(MAX)

		SET @return_query = '
			SELECT 
					Vehiculos.Id
					,Vehiculos.Placa
					,Vehiculos.Economico
					,Vehiculos.VIN
					,Vehiculos.MarcaId
					,Vehiculos.ModeloId
					,Vehiculos.Anio
					,Vehiculos.ColorId
					,Vehiculos.TipoCombustibleId
					,Vehiculos.TanqueCombustible
					,Vehiculos.RendimientoMixto
					,Vehiculos.RendimientoUrbano
					,Vehiculos.RendimientoSuburbano
					,Vehiculos.CapacidadVolumen
					,Vehiculos.CapacidadVolumenEfectivo
					,Vehiculos.ProveedorId
					,Vehiculos.EsquemaId
					,Vehiculos.Factura
					,Vehiculos.FacturaCarrocero
					,Vehiculos.ProveedorSeguroId
					,Vehiculos.PolizaSeguro
					,Vehiculos.Inciso
					,Vehiculos.Prima
					,Vehiculos.NumPermiso
					,Vehiculos.TipoPermiso
					,Vehiculos.ConfiguracionId
					,Vehiculos.TipoId
					,Vehiculos.ColaboradorId
					,Vehiculos.Maniobras
					,Vehiculos.Motor
					,Vehiculos.FactorCO2
					,Vehiculos.TagCaseta
					,Vehiculos.UltimoOdometro
					,Vehiculos.Estado
					,Vehiculos.Usuario
					,Vehiculos.Eliminado
					,Vehiculos.FechaCreacion
					,Vehiculos.Trail
				--Reemplaza el campo original GrupoVehiculo de la tabla Vehiculos
				,Vehiculos.GrupoVehiculo

				--Reemplaza el campo original HabilidadVehiculos de la tabla Vehiculos
				,Vehiculos.HabilidadVehiculos

				--Reemplaza el campo original RangoOperacion de la tabla Vehiculos
				,Vehiculos.RangoOperacion

				--Reemplaza el campo original UN de la tabla Vehiculos
				,Vehiculos.UN
				-- Tabla relacionadas con el vehículo
				'+ @camposObjetos +'
				--Tablas relacionadas para la app
				,Gps.Latitud AS Latitud
				,Gps.Longitud AS Longitud

				FROM [Vehiculos].[Vehiculos] Vehiculos
				INNER JOIN Vehiculos.Vehiculos VehiculosPivote ON Vehiculos.Id = VehiculosPivote.Id
				LEFT JOIN Vehiculos.Marcas Marcas ON Marcas.Id = Vehiculos.MarcaId
				LEFT JOIN Vehiculos.Modelos Modelos ON Modelos.Id = Vehiculos.ModeloId
				LEFT JOIN Vehiculos.Colores Colores ON Colores.Id = Vehiculos.ColorId
				LEFT JOIN Combustibles.TiposCombustibles TiposCombustibles ON TiposCombustibles.Id = Vehiculos.TipoCombustibleId
				LEFT JOIN Clientes.Proveedores Proveedores ON Proveedores.Id = Vehiculos.ProveedorId
				LEFT JOIN Vehiculos.Esquemas Esquemas ON Esquemas.Id = Vehiculos.EsquemaId
				LEFT JOIN Clientes.Proveedores ProveedorSeguros ON ProveedorSeguros.Id = Vehiculos.ProveedorSeguroId
				LEFT JOIN Vehiculos.Configuraciones Configuraciones ON Configuraciones.Id = Vehiculos.ConfiguracionId
				LEFT JOIN Vehiculos.Tipos VehiculosTipos ON VehiculosTipos.Id = Vehiculos.TipoId
				LEFT JOIN Operadores.Colaboradores Colaboradores ON Colaboradores.Id = Vehiculos.ColaboradorId
				LEFT JOIN GPS.GPS Gps ON Gps.VehiculoId = Vehiculos.Id
				------------------------------------------------------------------------------------
				' + @condicion + '
				ORDER BY Vehiculos.Id DESC
				OFFSET (' + CAST(@pageIndex AS VARCHAR(10)) + ' - 1) * ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS
				FETCH NEXT ' + CAST(@pageSize AS VARCHAR(10)) + ' ROWS ONLY ';
		PRINT @return_query;
		-- Se inserta en la tabla temporal los registros
		INSERT INTO @TablaTemporal (
			Id
			,Placa
			,Economico
			,Vin
			,MarcaId
			,ModeloId
			,Anio
			,ColorId
			,TipoCombustibleId
			,TanqueCombustible
			,RendimientoMixto
			,RendimientoUrbano
			,RendimientoSuburbano
			,CapacidadVolumen
			,CapacidadVolumenEfectivo
			,ProveedorId
			,EsquemaId
			,Factura
			,FacturaCarrocero
			,ProveedorSeguroId
			,PolizaSeguro
			,Inciso
			,Prima
			,NumPermiso
			,TipoPermiso
			,ConfiguracionId
			,TipoId
			,ColaboradorId
			,Maniobras
			,Motor
			,FactorCo2
			,TagCaseta
			,UltimoOdometro
			,Estado
			,Usuario
			,Eliminado
			,FechaCreacion
			,Trail
			,GrupoVehiculo
			,HabilidadVehiculos
			,RangoOperacion
			,Un
			,Marca
			,Modelo
			,Color
			,TipoCombustible
			,Proveedor
			,Esquema
			,ProveedorSeguro
			,Configuracion
			,Tipo
			,Colaborador
			,Latitud
			,Longitud
			--,Foto
		)
		EXEC sp_executesql @return_query;

		---- Obtiene la información de los registros y la convierte en un formato JSON
		DECLARE @sqlQuery NVARCHAR(MAX);
		-- Construye la consulta sin la paginacion y solo con los filtros
		SET @sqlQuery = 'SELECT COUNT(Id) AS TotalRows FROM [Vehiculos].[Vehiculos] Vehiculos ' + @condicion;
		-- Declara una variable para almacenar la cantidad de registros resultantes
		DECLARE @TotalRows TABLE(
			TotalRows int null
		)
		-- Ejecuta la consulta dinámicamente y almacena el resultado en @TotalRows
		INSERT INTO @TotalRows(TotalRows) EXEC sp_executesql @sqlQuery;

		-- Retorna los registros y luego TotalRows
		SELECT * FROM @TablaTemporal;
		SELECT TotalRows FROM @TotalRows AS TotalRows;

		SALIDA: 
		If(@AppMovil = 1)
		BEGIN
			SELECT * FROM @TablaTemporalMovil
		END
end
GO
