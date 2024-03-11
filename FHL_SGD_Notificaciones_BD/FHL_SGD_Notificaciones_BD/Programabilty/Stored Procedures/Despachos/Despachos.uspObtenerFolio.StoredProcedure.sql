USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerFolio]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      NewlandApps
-- Create date: Agosto de 2023
-- Description: Dado una tipo de folio (borrador de despacho o de un ticket), se compara si ya se habia ejecutado la secuencia o si no se manda a ejecutar
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerFolio]
    -- Add the parameters for the stored procedure here
	@TipoFolio					VARCHAR(11) = NULL,
    @CurrentFolio				bigint = 0
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;
    -- Variables de salida al ejecutar el SP
    DECLARE @Resultado  bigint = 0;
    DECLARE @Mensaje    VARCHAR(MAX) = NULL;

	/*
		Dependiendo cual sea el tipo de folio usara una secuencia diferente.
		Si el valor de @CurrentFolio es el mismo que tiene el current_value de la secuencia quiere decir que aun no se usa (no se ha quemado el folio) pero si no debe ejecutarse la funcion NEXT VALUE
	*/
	IF @TipoFolio = 'manifiesto' 
	BEGIN
		IF @CurrentFolio = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolio')
			SET @Resultado = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolio')
		ELSE 
			SET @Resultado = NEXT VALUE FOR Despachos.seqObtenerFolio;
	END
	ELSE IF @TipoFolio = 'ticket'
	BEGIN
		IF @CurrentFolio = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolioTicket')
			SET @Resultado = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolioTicket')
		ELSE 
			SET @Resultado = NEXT VALUE FOR Despachos.seqObtenerFolioTicket;
	END
	ELSE IF @TipoFolio = 'empaque'
	BEGIN
		IF @CurrentFolio = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolioEmpaque')
			SET @Resultado = (SELECT CONVERT(BIGINT, current_value) FROM sys.sequences WHERE name = 'seqObtenerFolioEmpaque')
		ELSE 
			SET @Resultado = NEXT VALUE FOR Despachos.seqObtenerFolioEmpaque;
	END
        -- Devuelve el resultado de la ejecución del SP junto con su respectivo mensaje
        SELECT
			@Resultado as JsonSalida;
END;
GO
