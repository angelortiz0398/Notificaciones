USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerVehiculosDisponibles]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Despachos].[uspObtenerVehiculosDisponibles]
as
Begin
	--No regresar dato de filas afectadas
	SET NOCOUNT ON;
	WITH Disponibles AS (
		SELECT Vehiculos.*
		FROM [Vehiculos].[Vehiculos] Vehiculos
		WHERE Vehiculos.Eliminado = 1
		AND NOT EXISTS (
			--Antigua validacion
			--SELECT 1
			--FROM [Despachos].[Visores] Visores
			--WHERE Vehiculos.VIN = Visores.Vehiculo
			--AND CAST(Visores.FechaRetorno AS DATE) = CAST(GETDATE() AS DATE) -- Que esten disponibles o no esten siendo usados en un manifiesto
			SELECT 1
			FROM Despachos.Despachos Despachos
			WHERE Despachos.VehiculoId = Vehiculos.Id -- Implica la relacion entre los Vehiculos y el vehiculo asignado al manifiesto
			AND (Despachos.EstatusId <> 2 OR Despachos.EstatusId <> 3) -- El estatus 2 y 3, significa que el manifiesto esta confirmado, o en proceso por lo que no puede utilizarse un vehiculo que esta actualmente en un manifiesto en curso
			AND Despachos.Eliminado = 1 -- Obliga a todos aquellos manifiestos que no han sido eliminados
		))
	--Inicia la construccion del JSON
	SELECT (SELECT COUNT(*) FROM Disponibles) as TotalRows,
		(SELECT *
			FROM Disponibles
		FOR JSON AUTO) AS JsonSalida;
end
GO
