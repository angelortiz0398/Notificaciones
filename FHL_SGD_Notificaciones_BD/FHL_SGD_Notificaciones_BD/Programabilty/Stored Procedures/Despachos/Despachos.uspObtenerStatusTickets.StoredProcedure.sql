USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerStatusTickets]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------
CREATE PROCEDURE [Despachos].[uspObtenerStatusTickets]
(
 @folio varchar(20)
)
AS
BEGIN
 -- No regresar dato de filas afectadas
 SET NOCOUNT ON;

 -- Selecciona los datos que deseas en el resultado JSON
 SELECT
  DISTINCT
  CASE
   WHEN EXISTS(
    SELECT
     1
    FROM
     [Despachos].[Tickets] ConsultaTicket
    JOIN
     [Despachos].[Visores] Visor
    ON
     ConsultaTicket.FolioTicket = Visor.Ticket
    WHERE
     Visor.Manifiesto = @folio
     AND ConsultaTicket.EstatusId IN (3, 4, 5)
   )
   THEN 'true'
   ELSE 'false'
  END AS JsonSalida
 FROM
  [Despachos].[Visores] Visor
 WHERE
  Visor.Manifiesto = @folio
END
GO
