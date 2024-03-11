USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerVisoresCustodia]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerVisoresCustodia]
							(
								@fechaInicio DATETIME = NULL, 
								@fechaFin DATETIME = NULL,
								@busqueda varchar(100) = ''
							)
as 
BEGIN
 -- No regresar dato de filas afectadas 
    SET NOCOUNT ON;
	-- Selecciona los datos que deseas en el resultado JSON
	SELECT
			(	
				SELECT
				[Visor].Id,
				[Visor].ManifiestoId,
				[Visor].Manifiesto,
				[Visor].Economico,
				[Visor].Placa,
				[Visor].Operador,
				[Visor].FechaCreacionViaje,
				ISNULL((SELECT Custodio.Id FROM [Despachos].[Custodias] Custodio WHERE Custodio.DespachoId = Visor.Id) , 0) AS CustodioId
				FROM [Despachos].[Visores] Visor
				-- Agregar una subconsulta   
				--Filtros de la busqueda
				Where (
						([Visor].Custodia = 1)
						AND
						(([Visor].FechaCreacionViaje >= @fechaInicio AND [Visor].FechaCreacionViaje <= @fechaFin)
					AND (@busqueda = '')
				 ) OR (
					[Visor].Manifiesto LIKE '%' + @busqueda + '%')
					  )				
			FOR JSON AUTO
			)					
	 AS JsonSalida;
END
GO
