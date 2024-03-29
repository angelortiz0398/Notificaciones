USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTicketAsignadosByManifiestoId]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Omar Leyva
-- Create date: Diciembre 2023
-- Description:	Obtiene los tickets asociados al manifiesto

CREATE PROCEDURE [Despachos].[uspObtenerTicketAsignadosByManifiestoId]
	@ManifiestoId int
as
BEGIN
 -- No regresar dato de filas afectadas
 SET NOCOUNT ON;
SELECT(
	SELECT * FROM Despachos.TicketsAsignados WHERE DespachoId = @ManifiestoId AND Eliminado = 1
	FOR JSON AUTO
	   )AS	JsonSalida
END
GO
