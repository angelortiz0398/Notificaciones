USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerTraficosPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerTraficosPaginado]
					(
					@pageIndex         int = 1,
					@pageSize		   int = 10,
					@fechaInicial	   DATETIME = NULL,
					@fechaFinal		   DATETIME = NULL,
					@busqueda		   varchar(100) = ''
					)
AS
BEGIN
	 -- TNE => TicketsNoEntregados
    -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
    WITH ConteoFolios AS (
        SELECT  FolioTicket,
        COUNT(*) AS CantidadDeVeces
        FROM [Despachos].[TicketsNoEntregados]
        GROUP BY FolioTicket
    )
	
    -- Actualiza el campo Reintentos en la tabla [Despachos].[TicketsNoEntregados]
    UPDATE TNE
    SET Reintentos = CF.CantidadDeVeces
    FROM [Despachos].[TicketsNoEntregados] TNE
    JOIN ConteoFolios CF ON CF.FolioTicket = TNE.FolioTicket
    
    -- Establece el valor inicial de Restantes
    UPDATE [Despachos].[TicketsNoEntregados]
    SET Restantes = 3
        
    -- Actualiza el campo Restantes restando el valor de Reintentos
    UPDATE TNE
    SET Restantes = Restantes - ISNULL(TNE.Reintentos, 0)
    FROM [Despachos].[TicketsNoEntregados] TNE
    WHERE TNE.Eliminado = 1;
    
    -- Selecciona los datos que deseas en el resultado JSON
    WITH TNETmp AS	
			(
				SELECT 
                [TicketNoEntregado].Id,
                [TicketNoEntregado].DespachoId,
                [TicketNoEntregado].TicketId,
				[TicketNoEntregado].Reintentos,
                [TicketNoEntregado].TipoEntregaId,
                [TicketNoEntregado].FolioDespacho,
                [TicketNoEntregado].FolioTicket,
                [TicketNoEntregado].CausaCambioId,
                [TicketNoEntregado].FechaCreacion,
			 --Jsons de la recuperacion de datos necesarios para cada Objeto
                JSON_QUERY((SELECT Tickets.FolioTicket FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Ticket,
				JSON_QUERY((SELECT Causas.DescripcionCausa FOR JSON PATH, WITHOUT_ARRAY_WRAPPER )) AS CausaCambio,
				JSON_QUERY(( SELECT	Visores.Manifiesto,Visores.FechaCreacionViaje FOR JSON PATH, WITHOUT_ARRAY_WRAPPER )) AS Despacho,
				[TicketNoEntregado].Restantes
            FROM [Despachos].[TicketsNoEntregados] TicketNoEntregado
            -- Definir LEFT JOIN para traer el Objeto Ticket
            LEFT JOIN [Despachos].[Tickets] Tickets ON Tickets.Id = TicketNoEntregado.TicketId
			-- Definir LEFT JOIN para traer el Objeto Ticket
            LEFT JOIN [Despachos].[Visores] Visores ON Visores.ManifiestoId = TicketNoEntregado.DespachoId
			-- Definir LEFT JOIN para traer el Objeto Causa
            LEFT JOIN [Despachos].[CausasCambios] Causas ON Causas.Id = TicketNoEntregado.CausaCambioId
			
		WHERE (TicketNoEntregado.FechaCreacion >= @fechaInicial AND TicketNoEntregado.FechaCreacion <= @fechaFinal)
					AND (@busqueda = '' OR TicketNoEntregado.FolioTicket LIKE '%' + LTRIM(RTRIM (@busqueda)) + '%'))
			-- Obtiene la información de los registros de TicketNo Entregado y lo convierte a  formato JSON
		SELECT
			(SELECT COUNT(*) FROM TNETmp) AS TotalRows,
			(
				SELECT * FROM TNETmp
				ORDER BY TNETmp.Id ASC

				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
