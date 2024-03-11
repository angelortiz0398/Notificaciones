USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerOperadoresDisponibles]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Despachos].[uspObtenerOperadoresDisponibles]
as
Begin
	--No regresar dato de filas afectadas
	--SET NOCOUNT ON;
	WITH Disponibles AS (
		SELECT Colaboradores.*
		FROM [Operadores].[Colaboradores] Colaboradores
		WHERE Colaboradores.TipoPerfilesId = 1 -- Filtro a todos los operadores
		AND Colaboradores.Eliminado = 1 -- Filtro por aquellos que no estan eliminados
		AND NOT EXISTS (
			--Antigua validacion
			--SELECT 1
			--FROM [Despachos].[Visores] Visores
			--WHERE Colaboradores.Nombre = Visores.Operador
			--AND CAST(Visores.FechaRetorno AS DATE) = CAST(GETDATE() AS DATE) -- Que esten disponibles o no esten siendo usados en un manifiesto
			SELECT 1
			FROM Despachos.Despachos Despachos
			WHERE Despachos.OperadorId = Colaboradores.Id -- Implica la relacion entre los Colaboradores y el operador asignado al manifiesto
			AND (Despachos.EstatusId <> 2 OR Despachos.EstatusId <> 3) -- El estatus 2 y 3, significa que el manifiesto esta confirmado, o en proceso por lo que no puede utilizarse un operador que esta actualmente en un manifiesto en curso
			AND Despachos.Eliminado = 1 -- Obliga a todos aquellos manifiestos que no han sido eliminados
		))
	--Inicia la construccion del JSON
	SELECT (SELECT COUNT(*) FROM Disponibles) as TotalRows,
		(
		SELECT *
			FROM Disponibles
		FOR JSON AUTO) AS JsonSalida;
end
GO
