USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerManifiestosArrays_V1]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Efren Portillo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerManifiestosArrays_V1]
	@userIdParam BIGINT = 0,
	@usuarioNameParam varchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT 
		@userIdParam as IdEmploye
		, CONCAT(bd.TipoFolio,CAST(bd.Folio AS varchar(max))) as FolioManifiesto
		,veh.Id as IdVehiculo
	from Despachos.BorradoresDespachos bd 
	INNER JOIN Despachos.Despachos d ON d.id = bd.id
	INNER JOIN Vehiculos.Vehiculos veh ON veh.Id = d.VehiculoId
	where bd.Usuario = @usuarioNameParam
	--and d.eliminado <>1
	--and condicion para que este vigente, pude ser la fecha o el status
	
END
GO
