USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GPS].[spInsertaMonitoreo360]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GPS].[spInsertaMonitoreo360] 
	@Monitoreo360 varchar(MAX) = NULL
AS


BEGIN
	-- SP de prueba para el componente que consume e inserta los datos de la API de Monitoreo360
	DECLARE @Resultado	INT = 0;
	DECLARE @Mensaje	VARCHAR(MAX) = 'Mensaje.';
	DECLARE @json VARCHAR(MAX) = @Monitoreo360;

	BEGIN TRANSACTION
		BEGIN
			BEGIN TRY
				insert into SGD_V1.GPS.GPSHistorial (Imei,Nombre,Licencia,Latitud,Longitud,Curso,Velocidad,Odometro,PuertaCabina,PuertaCarga,Bateria,UltimaPosicion,Usuario,Eliminado,FechaCreacion)
				select j.imei, j.name, j.license, j.lat, j.lng, j.course, j.speed, 
						j.odometer/1000, j.door, j.cargodoor, j.battery, 
						(SELECT DATEADD(ss, DATEDIFF(ss, getutcdate(), (SELECT DATEADD(ss, j.gmt, '19700101'))), GETdATE())), 'Monitoreo360', 1, GETDATE()
				from OPENJSON(@json) with (
					position NVARCHAR(MAX) '$.position' as JSON
				)
				cross APPLY OPENJSON(position) with (
					imei bigint '$.imei',
					name varchar(50) '$.name',
					license varchar(50) '$.license',
					lat numeric(18,6) '$.lat',
					lng numeric(18,6) '$.lng',
					course int '$.course',
					speed numeric(18,2) '$.speed',
					odometer numeric(18,2) '$.odometer',
					door varchar(50) '$.door',
					cargodoor varchar(50) '$.cargodoor',
					battery numeric(18,2) '$.battery',
					gmt bigint '$.gmt'
				) j
				WHERE j.imei is not null and j.name is not null;
				MERGE INTO SGD_V1.GPS.GPS as target 
				USING (
					SELECT j.imei, j.name, j.license, j.lat, j.lng, j.course, j.speed, 
						j.odometer/1000 as odometer, j.door, j.cargodoor, j.battery, 
						(SELECT DATEADD(ss, DATEDIFF(ss, getutcdate(), (SELECT DATEADD(ss, j.gmt, '19700101'))), GETdATE())) as last_position, GETDATE() as date_creation
					from OPENJSON(@json) with (
						position NVARCHAR(MAX) '$.position' as JSON
					)
					cross APPLY OPENJSON(position) with (
						imei bigint '$.imei',
						name varchar(50) '$.name',
						license varchar(50) '$.license',
						lat numeric(18,6) '$.lat',
						lng numeric(18,6) '$.lng',
						course int '$.course',
						speed numeric(18,2) '$.speed',
						odometer numeric(18,2) '$.odometer',
						door varchar(50) '$.door',
						cargodoor varchar(50) '$.cargodoor',
						battery numeric(18,2) '$.battery',
						gmt bigint '$.gmt'
					) j
					WHERE j.imei is not null and j.lat is not null and j.lng is not null and j.course is not null and j.name is not null 
						and j.lat <> 0 and j.lng <> 0 and j.course <> 0
				) as json_source on target.Nombre = json_source.name
				WHEN MATCHED THEN 
					UPDATE SET 
						target.Imei = json_source.imei,
						target.Licencia = json_source.license,
						target.Latitud = json_source.lat,
						target.Longitud = json_source.lng,
						target.Curso = json_source.course,
						target.Velocidad = json_source.speed,
						target.Odometro = json_source.odometer,
						target.PuertaCabina = json_source.door,
						target.PuertaCarga = json_source.cargodoor,
						target.Bateria = json_source.battery,
						target.UltimaPosicion = json_source.last_position,
						target.FechaCreacion = json_source.date_creation
				WHEN NOT MATCHED THEN 
					insert (Imei,Nombre,Licencia,Latitud,Longitud,Curso,Velocidad,Odometro,PuertaCabina,PuertaCarga,Bateria,UltimaPosicion,Usuario,Eliminado,FechaCreacion)
					values (json_source.imei, json_source.name, json_source.license, json_source.lat, json_source.lng, json_source.course, json_source.speed, json_source.odometer, json_source.door, json_source.cargodoor, json_source.battery, json_source.last_position,'Monitoreo360',1,GETDATE());				
				SET @Resultado = 100;
				SET @Mensaje = 'Exito.';
				COMMIT;
			END TRY
			BEGIN CATCH
				SET @Resultado = 200;
				SET @Mensaje = 'Error.';
				ROLLBACK;
			END CATCH
		END
	SALIDA:
		SELECT @Resultado AS Resultado, @Mensaje AS Mensaje;
END
GO
