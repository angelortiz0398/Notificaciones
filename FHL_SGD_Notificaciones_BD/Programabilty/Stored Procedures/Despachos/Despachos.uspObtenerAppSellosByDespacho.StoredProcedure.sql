USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAppSellosByDespacho]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Diciembre de 2023
-- Description:	Obtiene la información los Sellos ligados al Despacho pasado como parámetro junto con la información básica del propio despacho
-- =============================================
-- Parameters:	@FolioDespacho		=> Folio del Despacho del cual se quieren obtener los sellos
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAppSellosByDespacho]
	-- Add the parameters for the stored procedure here
	@FolioDespacho				VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Declaración de varibles utilizadas en el script
	DECLARE @ResponseCode		INT = 0;
	DECLARE @Message			VARCHAR(MAX) = 'Ejecución completada correctamente';
	DECLARE @Data				VARCHAR(MAX) = NULL;
	-- Número de registros totales antes de la paginación
	DECLARE @TotalRows			INT = 0;
	-- Tabla variable para el manejo de la información
	DECLARE @CteSellos TABLE(
		Id						BIGINT,
		DespachoId				BIGINT,
		Sello					VARCHAR(MAX)
	)


	-- Valida la información recibida como parámetro
	IF @FolioDespacho IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible consultar los sellos porque no se ha proporcionado el folio del Despacho';
			GOTO SALIDA;			
		END
	ELSE
		BEGIN
			-- Determina si el despacho se encuentra registrado
			SELECT @TotalRows = Id
			FROM Despachos.Despachos
			WHERE FolioDespacho = @FolioDespacho
			AND Eliminado = 1;

			IF @TotalRows = 0
				BEGIN
					SET @ResponseCode = -2;
					SET @TotalRows = @ResponseCode;
					SET @Message = 'El Despacho proporcionado no existe o ha sido eliminado';
					GOTO SALIDA;					
				END
		END


	-- Recupera la información de los Sellos ligados al Despacho pasado como parámetro
	INSERT INTO @CteSellos
		SELECT
			Sellos.Id,
			Sellos.DespachoId,
			Sellos.Sello
		FROM Despachos.Sellos Sellos
		INNER JOIN Despachos.Despachos Despachos
			ON Despachos.Id = Sellos.DespachoId
			AND Despachos.Eliminado = 1
		WHERE UPPER(Despachos.FolioDespacho) = UPPER(@FolioDespacho);
	-- Determina el número de registros encontrados (Sellos)
	SELECT @TotalRows = COUNT(*) FROM @CteSellos;

	

	-- Devuelve la información recopilada en la ejecución del script
	SALIDA:
		-- Determina si debe mostrar el número de registros encontrados o el error generado
		IF @ResponseCode >= 0 SET @ResponseCode = @TotalRows ELSE SET @TotalRows = @ResponseCode;
		
		-- Devuelve las columnas de información
		SELECT
			@TotalRows AS TotalRows,	
			'{' +
				'"responseCode": ' + CAST(@ResponseCode AS VARCHAR(MAX)) + ',' +
				'"message":"' + @Message + '",' +
				'"data":' + (
					CASE
						-- Información de los Despachos
						WHEN @ResponseCode >= 0 AND @TotalRows > 0 THEN
							(
								SELECT
									Despachos.Id,
									Despachos.FolioDespacho,
									Despachos.Origen,
									Despachos.Destino,
									Despachos.FechaCreacion,
									JSON_QUERY
										(
											(
												SELECT
													Id,
													Sello AS numeroSello,
													DespachoId
												FROM @CteSellos
												FOR JSON PATH
											)
										) AS Sellos
								FROM Despachos.Despachos
									WHERE UPPER(Despachos.FolioDespacho) = UPPER(@FolioDespacho)
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
							)
						-- No hay información para mostrar ya que ha ocurrido un error
						-- Se devuelve "" por tratarse solo de un Objeto aunque internamente tenga una lista
						ELSE '""' END
				) +
			'}' AS JsonSalida;
END
GO
