USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAppCortinasByDespacho]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Diciembre de 2023
-- Description:	Obtiene la información del Despacho pasado como parámetro junto con la información del Anden donde se atiende dicho Despacho
-- =============================================
-- Parameters:	@FolioDespacho		=> Folio del Despacho del cual se quiere obtener el anden
--				@AndenId			=> Identificador específico del anden. En caso de ser pasado como parámetro, devuelve ade´más la información del CEDIS en donde está ubicado el Anden
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAppCortinasByDespacho]
	-- Add the parameters for the stored procedure here
	@FolioDespacho				VARCHAR(20)		= NULL,
	@CodigoAnden				VARCHAR(MAX)	= NULL
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
	DECLARE @CteAndenes TABLE(
		Id					BIGINT,
		CedisID				BIGINT,
		Nombre				VARCHAR(MAX),
		AndenCortina		BIT,	
		CodigoAnden			VARCHAR(MAX)
	)


	-- Valida la información recibida como parámetro
	IF @FolioDespacho IS NULL
		BEGIN
			-- No se estableció el Operador para consultar
			SET @ResponseCode = -1;
			SET @Message = 'No es posible consultar las cortinas porque no se ha proporcionado el folio del Despacho';
			GOTO SALIDA;			
		END
	ELSE
		BEGIN
			-- Determina si el despacho se encuentra registrado
			SELECT @TotalRows = Id FROM Despachos.Despachos
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


	-- Recupera la información del Anden ligada al Despacho pasado como parámetro
	INSERT INTO @CteAndenes
		SELECT
			Andenes.Id,
			Andenes.CedisID,
			Andenes.Nombre,
			Andenes.AndenCortina,
			Andenes.CodigoAnden
		FROM Despachos.Andenes Andenes
			INNER JOIN Despachos.Despachos Despachos
				ON Despachos.AndenId = Andenes.Id
				AND Despachos.Eliminado = 1
		WHERE
			UPPER(Despachos.FolioDespacho) = UPPER(@FolioDespacho)
			AND (@CodigoAnden IS NULL OR Andenes.CodigoAnden = @CodigoAnden);
	-- Determina el número de registros encontrados (Cortinas)
	SELECT @TotalRows = COUNT(*) FROM @CteAndenes;


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
									-- Información del Anden (Cortina)
									Despachos.AndenId,
									JSON_QUERY
									(
										(
											SELECT
												CteAnden.Id,
												CteAnden.Nombre,
												CteAnden.AndenCortina,
												CteAnden.CodigoAnden,
												-- Información del CEDIS
												CteAnden.CedisID,
												JSON_QUERY(
													(
														CASE WHEN @CodigoAnden IS NOT NULL THEN
															(
																SELECT
																	CentrosDistribuciones.Id,
																	CentrosDistribuciones.Nombre,
																	CentrosDistribuciones.Descripcion,
																	CentrosDistribuciones.Geolocalizacion
																FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
															)
														END
													)
												) AS Cedis
											FROM @CteAndenes CteAnden
											LEFT JOIN Operadores.CentrosDistribuciones
												ON CentrosDistribuciones.Id = CteAnden.CedisID
											FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
										)
									) AS Anden
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
