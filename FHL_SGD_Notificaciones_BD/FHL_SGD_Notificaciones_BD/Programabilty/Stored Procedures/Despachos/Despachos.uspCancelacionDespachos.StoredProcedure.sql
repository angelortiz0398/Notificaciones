USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspCancelacionDespachos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspCancelacionDespachos](@Folio varchar(20))
AS
BEGIN
--Asignar estatus #5 -> Cancelado
UPDATE Despachos.Despachos SET EstatusId = 5 WHERE FolioDespacho = @Folio;
END
GO
