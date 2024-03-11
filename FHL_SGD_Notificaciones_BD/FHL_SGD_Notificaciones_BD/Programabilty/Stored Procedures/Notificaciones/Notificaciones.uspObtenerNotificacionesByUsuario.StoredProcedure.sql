USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerNotificacionesByUsuario]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Octubre de 2023
-- Description:	Devuelve la lista de notificaciones a mostrar en la Bandeja del Usuario
--				TotalRows:	Devuelve un número positivo cuando se hayan encontrado notificaciones a mostrar y un negativo cuando exista algún problema de ejecución
--				JsonSalida: Devuelve el JSON con la lista de notificaciones pero además un mensaje en caso de error en la ejecución
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspObtenerNotificacionesByUsuario]
	-- Add the parameters for the stored procedure here
	@IdUsuario				INT = NULL,
	@FechaInicial			DATETIME = NULL,
	@FechaFinal				DATETIME = NULL,
	@Notificacion			VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Define las variables a utilizar a lo largo del SP
	DECLARE @Resultado					INT = 0;				-- Indica si la ejecución del script se llevó a cabo correctamente
	DECLARE @Mensaje					VARCHAR(MAX) = NULL;	-- Mensaje de error en caso de que exista algún problema en la ejecución del script
	DECLARE @NumRegistrosTotales		INT = 0;				-- Indica cuantos registros totales fueron pasados en la cadena JSON de entrada
	DECLARE @NumRegistrosInsertados		INT = 0;				-- Indica cuantos registros fueron insertados correctamente en la tabla correspondiente
	DECLARE @ListaNotificaciones TABLE(
		-- Info de la Alerta
		Id					INT,
		FechaLlegada		DATETIME,
		FechaCreacionAlerta	DATETIME,
		Lectura				BIT,
		Usuario				VARCHAR(150),
		Eliminado			BIT,
		FechaCreacion		DATETIME,
		Trail				VARCHAR(MAX),
		-- Info del colaborador
		ColaboradoresId		INT,
		-- Info de la alerta
		AlertasId			INT
	);


	-- Valida que se hayan pasado los parámetros necesarios para la generación de la información
	IF @IdUsuario IS NULL OR @FechaInicial IS NULL OR @FechaFinal IS NULL
		BEGIN
			SET @Resultado = -1;
			SET @Mensaje = 'No se ha establecido el Colaborador, la fecha de inicio y/o la fecha final de la cual desea obtener notificaciones';
			GOTO SALIDA;
		END


	-- Obtiene las notificaciones de acuerdo a los parámetros de entrada
	INSERT INTO @ListaNotificaciones
		SELECT
			NotiBandejas.Id,
			NotiBandejas.FechaLlegada,
			NotiBandejas.FechaCreacionAlerta,
			NotiBandejas.Lectura,
			NotiBandejas.Usuario,
			NotiBandejas.Eliminado,
			NotiBandejas.FechaCreacion,
			NotiBandejas.Trail,
			-- Info del colaborador
			NotiBandejas.ColaboradoresId,
			-- Info de la alerta
			NotiBandejas.AlertasId
		FROM Notificaciones.Bandejas NotiBandejas
		WHERE NotiBandejas.Eliminado = 1
			AND NotiBandejas.ColaboradoresId = @IdUsuario
			AND NotiBandejas.FechaCreacionAlerta BETWEEN @FechaInicial AND @FechaFinal;


    -- Devuelve la lista de Notificaciones asignadas al Usuario y las convierte en un JSON
	SALIDA:
		-- Número de registros para tratar de insertar
		SELECT @NumRegistrosTotales = COUNT(*) FROM @ListaNotificaciones;
		-- Mensaje de salida en formato JSON (lista de notificaciones)
		SELECT @Mensaje = '{' +
								'"registrosTotales":' +
									(
										CASE
											WHEN @Resultado >= 0 THEN CAST(@NumRegistrosTotales AS VARCHAR(MAX))
											ELSE CAST(@Resultado AS VARCHAR(MAX)) END
									) + ',' +
								'"notificaciones":' +
									(
										CASE
											-- No existen errores y se han encontrado notificaciones para mostrar
											WHEN @Resultado >= 0 AND @NumRegistrosTotales > 0 THEN
												(
													SELECT
														L_N.*,
														-- Recupera la lista de columnas para generar el objeto Colaboradores y evitar que se convierta en una cadena texto en lugar de un Objeto
														-- cuando se aplica FOR JSON PATH
														JSON_QUERY(
															(
																SELECT
																	Colab.Id,
																	Colab.Nombre
																	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														) AS Colaboradores,
														-- Recupera la lista de columnas para generar el objeto Colaboradores y evitar que se convierta en una cadena texto en lugar de un Objeto
														-- cuando se aplica FOR JSON PATH
														JSON_QUERY(
															(
																SELECT
																	Alerts.Id,
																	Alerts.TextoAlerta
																	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														) AS Alertas
													FROM @ListaNotificaciones L_N
													INNER JOIN Notificaciones.Alertas Alerts
														ON L_N.AlertasId = Alerts.Id
													INNER JOIN Operadores.Colaboradores Colab
														ON Colab.Id = L_N.ColaboradoresId
													ORDER BY L_N.FechaLlegada DESC
													FOR JSON PATH
												)
											-- No hay errores pero tampoco no hay elementos a mostrar
											ELSE '""' END
									) + ',' +
								'"mensajesError":' +
									(
										CASE
											-- Ha ocurrido algún problema para ejecutar el script
											WHEN @Resultado < 0 THEN '"' + @Mensaje + '"'
											-- Sin problemas para ejecutar el script
											ELSE '""' END
									) +
							'}';
		-- Lista de notificaciones a devolver al ejecutar el script o errores según corresponda
		SELECT
			CASE WHEN @Resultado >= 0 THEN @NumRegistrosTotales ELSE @Resultado END AS TotalRows,
			@Mensaje AS JsonSalida;
END
GO
