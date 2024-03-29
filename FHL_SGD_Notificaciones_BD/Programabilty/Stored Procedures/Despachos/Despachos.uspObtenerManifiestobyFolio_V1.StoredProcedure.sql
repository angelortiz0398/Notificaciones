USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerManifiestobyFolio_V1]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Despachos].[uspObtenerManifiestobyFolio_V1]
	@folioParam varchar(max)
AS
BEGIN

	SELECT 
		CAST(v.Folio AS varchar(max)) as Folio,
		d.Ticket,
		c.RazonSocial as cliente, 
		'general docs' as general_docs,
		'contact' as contact,
		'addDocs' as addDocs,
		'productos' as productos,
		bd.CheckList as checkList
	from Despachos.Visores v
	left JOIN Despachos.BorradoresDespachos bd ON bd.Folio = v.Folio
	left JOIN Despachos.Despachos d ON d.id = bd.id
	INNER JOIN Vehiculos.Vehiculos veh ON veh.Id = d.VehiculoId
	inner join Clientes.Clientes c on c.Id = bd.ClienteId
	where v.Folio = @folioParam
	
	
END

GO
