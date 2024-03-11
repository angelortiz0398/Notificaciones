USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspActualizarEstatusTicket]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Despachos].[uspActualizarEstatusTicket]
	@IdTicket int
AS
BEGIN
 -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
DECLARE @Estatus int
UPDATE Despachos.Tickets 
SET EstatusId = 2
WHERE Id = @IdTicket;
SELECT(	
			SELECT * FROM Despachos.Tickets WHERE Id = @IdTicket
					--PARA REGRASAR UN OBJETO 
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER 
		)AS JsonSalida
END
GO
