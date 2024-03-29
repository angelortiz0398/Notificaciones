USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerVisoresCustodiaPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      NewlandApps
-- Create date: Diciembre del 2023
-- Description: Consulta de los visores que requieren custodio en el modúlo de despachos
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerVisoresCustodiaPaginado]
							(
								@pageIndex         int = 1,
								@pageSize		   int = 10,
								@fechaInicial	   DATETIME = NULL, 
								@fechaFinal		   DATETIME = NULL,
								@busqueda		   varchar(100) = ''
							)
as 
BEGIN
 -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
	-- Selecciona los datos que deseas en el resultado JSON
	WITH CustodiaTmp AS
			(	
				SELECT
				[Visor].Id,
				[Visor].ManifiestoId,
				[Visor].Manifiesto,
				[Visor].Economico,
				[Visor].Placa,
				[Visor].Operador,
				[Visor].FechaCreacionViaje,
				-- Agregar una subconsulta   
				ISNULL((SELECT Custodio.Id FROM [Despachos].[Custodias] Custodio WHERE Custodio.DespachoId = Visor.Id) , 0) AS CustodioId
				FROM [Despachos].[Visores] Visor
				--Filtros de la busqueda
					 WHERE Visor.Custodia = 1 AND Visor.FechaCreacionViaje >= @fechaInicial AND Visor.FechaCreacionViaje <= @fechaFinal
					 	AND (@busqueda = '' OR Visor.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'))
			-- Obtiene la información de los registros de TicketNo Entregado y lo convierte a  formato JSON
		SELECT
			(SELECT COUNT(*) FROM CustodiaTmp) AS TotalRows,
			(
				SELECT * FROM CustodiaTmp
				ORDER BY CustodiaTmp.Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
