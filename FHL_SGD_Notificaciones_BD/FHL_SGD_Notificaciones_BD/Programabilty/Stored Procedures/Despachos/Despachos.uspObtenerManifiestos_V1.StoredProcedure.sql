USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerManifiestos_V1]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerManifiestos_V1]
	@userIdParam BIGINT = 0
AS
BEGIN

	SELECT 
		v.Folio,
		bd.Referencia,
		veh.Placa,
		d.Origen,
		'Por agregar' as supervisor
	from Despachos.Visores v
	left JOIN Despachos.BorradoresDespachos bd ON bd.Folio = v.Folio
	left JOIN Despachos.Despachos d ON d.id = bd.id
	INNER JOIN Vehiculos.Vehiculos veh ON veh.Id = d.VehiculoId
	--where v.Usuario = @userNameParam
	
	
END

GO
