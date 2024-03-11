USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerVehiculos]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Vehículos activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================
CREATE PROCEDURE [Vehiculos].[uspObtenerVehiculos]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

		;WITH CteTmp AS(
			SELECT
				VehiculosTabla.Id,
				VehiculosTabla.Placa,
				VehiculosTabla.Economico,
				VehiculosTabla.VIN,
				VehiculosTabla.Anio,
				VehiculosTabla.TanqueCombustible,
				VehiculosTabla.RendimientoMixto,
				VehiculosTabla.RendimientoUrbano,
				VehiculosTabla.RendimientoSuburbano,
				VehiculosTabla.CapacidadVolumen,
				VehiculosTabla.CapacidadVolumenEfectivo,
				VehiculosTabla.Factura,
				VehiculosTabla.FacturaCarrocero,
				VehiculosTabla.PolizaSeguro,
				VehiculosTabla.Inciso,
				VehiculosTabla.Prima,
				VehiculosTabla.NumPermiso,
				VehiculosTabla.TipoPermiso,
				VehiculosTabla.Maniobras,
				VehiculosTabla.Motor,
				VehiculosTabla.FactorCO2,
				VehiculosTabla.TagCaseta,
				VehiculosTabla.UltimoOdometro,
				VehiculosTabla.Estado,
				VehiculosTabla.Usuario,
				VehiculosTabla.Eliminado,
				VehiculosTabla.FechaCreacion,
				VehiculosTabla.Trail,

				-- Tabla relacionadas con el vehículo
				VehiculosTabla.MarcaId,
				JSON_QUERY((SELECT LTRIM(RTRIM(Marcas.Nombre)) AS Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Marca,
				VehiculosTabla.ModeloId,
				JSON_QUERY((SELECT Modelos.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Modelo,
				VehiculosTabla.ColorId,
				JSON_QUERY((SELECT Colores.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Color,
				VehiculosTabla.TipoCombustibleId,
				JSON_QUERY((SELECT TiposCombustibles.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCombustible,
				VehiculosTabla.ProveedorId,
				JSON_QUERY((SELECT Proveedores.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Proveedor,
				VehiculosTabla.EsquemaId,
				JSON_QUERY((SELECT Esquemas.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Esquema,
				VehiculosTabla.ProveedorSeguroId,
				JSON_QUERY((SELECT ProveedorSeguros.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS ProveedorSeguro,
				VehiculosTabla.ConfiguracionId,
				JSON_QUERY((SELECT Configuraciones.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Configuracion,
				VehiculosTabla.TipoId,
				JSON_QUERY((SELECT Tipos.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Tipo,
				VehiculosTabla.ColaboradorId,
				JSON_QUERY((SELECT Operador.Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaborador,

				--Reemplaza el campo original GrupoVehiculo de la tabla Vehiculos
				(
					STUFF(
						(
							SELECT ', ' + Nombre 
							FROM Vehiculos.Grupos Grupos
							WHERE Grupos.Id IN (
								SELECT GrupoId
								FROM Vehiculos.GruposDetalles
								WHERE VehiculoId = VehiculosPivote.Id
								AND Eliminado = 1
							)
							FOR XML PATH ('')
						)
					,1,2,'')
				) AS GrupoVehiculo,
				--Reemplaza el campo original HabilidadVehiculos de la tabla Vehiculos
				(
					STUFF(
						(
							SELECT ', ' + Nombre 
							FROM Vehiculos.HabilidadesVehiculos
							WHERE Id IN (
								SELECT CAST(JSON_VALUE(value, '$.id') AS INT)
								FROM OPENJSON
									(
										(
											SELECT HabilidadVehiculos
											FROM Vehiculos.Vehiculos
											WHERE Vehiculos.Id = VehiculosPivote.Id
											AND Eliminado = 1
										)--, '$.habilidades'
									)
							)
							FOR XML PATH ('')
						)
					,1,2,'')
				) AS HabilidadVehiculos,
				--Reemplaza el campo original RangoOperacion de la tabla Vehiculos
				(
					STUFF(
						(
							SELECT ', ' + Nombre 
							FROM Clientes.RangosOperaciones
							WHERE Id IN (
								SELECT CAST(JSON_VALUE(value, '$.id') AS INT)
								FROM OPENJSON
									(
										(
											SELECT RangoOperacion
											FROM Vehiculos.Vehiculos
											WHERE Vehiculos.Id = VehiculosPivote.Id
											AND Eliminado = 1
										)--, '$.rangos'
									)
							)
							FOR XML PATH ('')
						)
					,1,2,'')
				) AS RangoOperacion,
				--Reemplaza el campo original UN de la tabla Vehiculos
				(
					STUFF(
						(
							SELECT ', ' + Nombre 
							FROM Productos.UN
							WHERE Id IN (
								SELECT CAST(JSON_VALUE(value, '$.id') AS INT)
								FROM OPENJSON
									(
										(
											SELECT UN
											FROM Vehiculos.Vehiculos
											WHERE Vehiculos.Id = VehiculosPivote.Id
											AND Eliminado = 1
										)--, '$.uns'
									)
							)
							FOR XML PATH ('')
						)
					,1,2,'')
				) AS UN
			FROM Vehiculos.Vehiculos VehiculosTabla
				INNER JOIN Vehiculos.Vehiculos VehiculosPivote ON VehiculosTabla.Id = VehiculosPivote.Id
				INNER JOIN Vehiculos.Marcas Marcas ON Marcas.Id = VehiculosTabla.MarcaId
				INNER JOIN Vehiculos.Modelos Modelos ON Modelos.Id = VehiculosTabla.ModeloId
				INNER JOIN Vehiculos.Colores Colores ON Colores.Id = VehiculosTabla.ColorId
				INNER JOIN Combustibles.TiposCombustibles TiposCombustibles ON TiposCombustibles.Id = VehiculosTabla.TipoCombustibleId
				LEFT JOIN Clientes.Proveedores Proveedores ON Proveedores.Id = VehiculosTabla.ProveedorId
				LEFT JOIN Vehiculos.Esquemas Esquemas ON Esquemas.Id = VehiculosTabla.EsquemaId
				LEFT JOIN Clientes.Proveedores ProveedorSeguros ON ProveedorSeguros.Id = VehiculosTabla.ProveedorSeguroId
				LEFT JOIN Vehiculos.Configuraciones Configuraciones ON Configuraciones.Id = VehiculosTabla.ConfiguracionId
				LEFT JOIN Vehiculos.Tipos Tipos ON Tipos.Id = VehiculosTabla.TipoId
				LEFT JOIN Operadores.Colaboradores Operador ON Operador.Id = VehiculosTabla.ColaboradorId
			WHERE VehiculosTabla.Eliminado = 1
		)

	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
				FOR JSON PATH
			) AS JsonSalida;
END
GO
