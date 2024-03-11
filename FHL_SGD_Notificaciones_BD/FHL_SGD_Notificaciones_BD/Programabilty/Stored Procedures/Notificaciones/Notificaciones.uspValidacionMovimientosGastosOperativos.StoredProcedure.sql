USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspValidacionMovimientosGastosOperativos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Erick Dominguez
-- Create date: MARZO 2024
-- Description:	

-- =============================================
CREATE PROCEDURE [Notificaciones].[uspValidacionMovimientosGastosOperativos]
		@Intervalo TIME -- Parametro para recibir el intervalo de tiempo
AS
BEGIN
    SET NOCOUNT ON;
		DECLARE @FechaInicio DATETIME = DATEADD(SECOND, -DATEDIFF(SECOND, '00:00:00', @Intervalo), GETDATE());
		DECLARE @FechaFin DATETIME = DATEADD(HOUR, 6,GETDATE());
		DECLARE @GastosEnIntervalo BIT;
		DECLARE @RegistrosDispersionJson NVARCHAR(MAX);
		DECLARE @Informacion Nvarchar(MAX);
		DECLARE @ColaboradoresJson NVARCHAR(MAX);



    -- Verificar si ha existido un movimiento en Gastos operativos para un colaborador 
    IF EXISTS (
		--Verificar si existe movimiento en Registro Dispersión
			SELECT 1 
			FROM Despachos.RegistrosDispersiones
			CROSS APPLY OPENJSON(Trail)
				WITH (
					trail_timemark DATETIMEOFFSET
				) AS TrailInfo
			WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
			)
		--Verificar si existe movimiento en Registro Liquidación  
		OR EXISTS (
			SELECT 1 
			FROM Despachos.RegistrosLiquidaciones
			CROSS APPLY OPENJSON(Trail)
				WITH (
					trail_timemark DATETIMEOFFSET
				) AS TrailInfo
			WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
			) 
		-- Verificar si existe movimiento en Registro Ajuste
		OR EXISTS (
			SELECT 1 
			FROM Despachos.RegistroAjuste
			CROSS APPLY OPENJSON(Trail)
				WITH (
					trail_timemark DATETIMEOFFSET
				) AS TrailInfo
			WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
			)
		BEGIN
			SET @GastosEnIntervalo = 1; --Enviaremos un verdadero
        
			-- Obtener datos de colaboradores con movimientos en RegistrosDispersión, RegistrosLiquidación o RegistrosAjustes
			SELECT @ColaboradoresJson = (
				SELECT
				--Emails:
					emails = (
						SELECT DISTINCT CorreoElectronico AS email
						FROM Operadores.Colaboradores
						--RegistrosDispersion
						WHERE Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosDispersiones
							CROSS APPLY OPENJSON(Trail)
								WITH (
									trail_timemark DATETIMEOFFSET
								) AS TrailInfo
								WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosLiquidación 
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosLiquidaciones
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosAjustes
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistroAjuste
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						)
						FOR JSON PATH
					),

					phones = (
						SELECT DISTINCT Telefono AS phone
						FROM Operadores.Colaboradores
						WHERE Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosDispersiones
							CROSS APPLY OPENJSON(Trail)
								WITH (
									trail_timemark DATETIMEOFFSET
								) AS TrailInfo
								WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosLiquidación 
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosLiquidaciones
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosAjustes
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistroAjuste
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						)
						FOR JSON PATH
					),
					users = (
                    SELECT Id AS userId
                    FROM Operadores.Colaboradores
                    WHERE Id IN (
                        SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosDispersiones
							CROSS APPLY OPENJSON(Trail)
								WITH (
									trail_timemark DATETIMEOFFSET
								) AS TrailInfo
								WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosLiquidación 
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistrosLiquidaciones
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						) --RegistrosAjustes
						OR Id IN (
							SELECT DISTINCT ColaboradorId
							FROM Despachos.RegistroAjuste
						   CROSS APPLY OPENJSON(Trail)
							WITH (
								trail_timemark DATETIMEOFFSET
							) AS TrailInfo
							WHERE TrailInfo.trail_timemark between @FechaInicio AND @FechaFin
						)
                    FOR JSON PATH
                )
				FOR JSON PATH
			);

			SET @Informacion = 'Cuentas con movimientos en gastos operativos';
    END
    ELSE
    BEGIN
        SET @GastosEnIntervalo = 0;
		SET @ColaboradoresJson = N'[{"emails":[],"phones":[],"users":[]}]';
    END

    SELECT 
        Resultado = @GastosEnIntervalo,
        ListaContactos = @ColaboradoresJson,
		InformacionAdicional = @Informacion;
END
GO
