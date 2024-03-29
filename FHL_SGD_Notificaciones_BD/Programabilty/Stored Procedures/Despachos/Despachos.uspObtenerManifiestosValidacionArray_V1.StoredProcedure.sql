USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerManifiestosValidacionArray_V1]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Efren Portillo
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerManifiestosValidacionArray_V1]
	@userIdParam BIGINT = 0,
	@usuarioNameParam varchar(max),
	@folioNameParam varchar(max)
AS
BEGIN


		select(
		SELECT 
			(select 
				id,
				Nombre,
				CorreoElectronico,
				Telefono
			from [Operadores].Colaboradores ope
			where d.OperadorId = ope.Id
			FOR JSON PATH) as empleado,
			(select 
				id,
				Placa,
				Economico
			from [Vehiculos].Vehiculos ve2
			where d.VehiculoId = ve2.Id
			FOR JSON PATH) as vehiculo,
			(select 
				FolioDespacho,
				origen,
				VehiculoId,
				v.Placa
			from [Despachos].Despachos d2
			where d.Id = d2.Id
			FOR JSON PATH) as despacho
		from Despachos.Visores viso 
		INNER JOIN Despachos.Despachos d ON d.id = viso.id
		left join Vehiculos.Vehiculos v on d.VehiculoId =v.Id
		--where bd.Usuario = @usuarioNameParam
		--and bd.Folio = @folioNameParam
		--and d.eliminado <>1
		--and condicion para que este vigente, pude ser la fecha o el status
		FOR JSON PATH) as json
END
GO
