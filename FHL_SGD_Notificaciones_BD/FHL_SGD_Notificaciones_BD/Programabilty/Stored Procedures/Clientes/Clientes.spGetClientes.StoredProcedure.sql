USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[spGetClientes]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Clientes].[spGetClientes] 
	
AS
BEGIN
	
	SELECT Id,
	RazonSocial,
	RFC as Rfc,
	AxaptaId,
	Eliminado,
	FechaCreacion,
	Usuario,
	Trail

	from Clientes

	where Eliminado = 1
END
GO
