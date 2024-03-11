USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerManifiestosPorEstatus]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Solicitudes de combustibles activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Despachos].[uspObtenerManifiestosPorEstatus]
    @jsonEstatus NVARCHAR(MAX) ='[]'
AS
BEGIN
	DECLARE @EstatusTabla TABLE (Estado bigint); --Tabla en la cual guardaremos los estados provenientes del json

    -- Deserializar el JSON en la variable de tabla
    INSERT INTO @EstatusTabla
    SELECT Estado
    FROM OPENJSON(@jsonEstatus)
    WITH (Estado INT '$'); -- Se utiliza '$' por que este indica que esta en el primer nivel el dato solicitado

    -- Convertimos en un json la consulta y hacemos un select de esta para asignarle a todo el nombre requerido
	SELECT(
		SELECT *
		FROM Despachos.Despachos 
		WHERE Despachos.Eliminado = 1 AND Despachos.EstatusId IN (SELECT Estado FROM @EstatusTabla) FOR JSON PATH) AS JsonSalida;
    
END
GO
