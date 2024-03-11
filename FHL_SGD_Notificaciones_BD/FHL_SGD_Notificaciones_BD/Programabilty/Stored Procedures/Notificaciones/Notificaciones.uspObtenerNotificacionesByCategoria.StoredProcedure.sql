USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerNotificacionesByCategoria]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Newlandapps
-- Create date: Agosto de 2023
-- Description:	Obtiene la lista general de notificaciones dadas de alta en la tabla Notificaciones.Notificaciones
-- =============================================
CREATE PROCEDURE [Notificaciones].[uspObtenerNotificacionesByCategoria]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Genera un CTE para obtener la información deseada incluyendo el número de registros ya que solo se hará un COUNT sin necesidad de volver a generar una consulta idéntica
	;WITH CteTmp AS(
		SELECT
			N_Categorias.Id AS CategoriaNotificacionId,
			N_Categorias.Nombre AS CategoriaNotificacionNombre,
			(
				JSON_QUERY(
						(
							SELECT N_Notificaciones_Current.*
							FROM Notificaciones.CategoriasNotificaciones N_Notificaciones_Current
							WHERE N_Notificaciones_Current.Id = N_Categorias.Id
							AND N_Notificaciones_Current.Eliminado = 1
							FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
						)
					)
			) AS CategoriaNotificacion,
			(
				-- Subquery para obtener la lista de Notificaciones que pertenecen a cada Categoría encontrada en la consulta principal en formato JSON
				JSON_QUERY(
					(
						SELECT
							N_Notificaciones.Id,
							N_Notificaciones.Nombre,
							N_Notificaciones.Activada,
							N_Notificaciones.Condiciones,
							N_Notificaciones.ListaContactos,
							JSON_QUERY(N_Notificaciones.Reglas) AS Regla, -- Utilizar JSON_QUERY para convertir Reglas a JSON
							N_Notificaciones.NotificarPorId,
							N_Notificaciones.CategoriasNotificacionesId,
							N_Notificaciones.Usuario,
							N_Notificaciones.Eliminado,
							N_Notificaciones.FechaCreacion,
							N_Notificaciones.Trail
						FROM Notificaciones.Notificaciones N_Notificaciones
						WHERE N_Notificaciones.CategoriasNotificacionesId = N_Categorias.Id
						AND N_Notificaciones.Eliminado = 1
						ORDER BY N_Notificaciones.Nombre
						FOR JSON PATH
					)
				)
			) AS Items
		FROM Notificaciones.CategoriasNotificaciones N_Categorias
		WHERE N_Categorias.Eliminado = 1
	)

	-- Obtiene la información y la convierte en un formato JSON
	SELECT
		(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
		(
			SELECT
				CategoriaNotificacionId,
				CategoriaNotificacionNombre,
				CategoriaNotificacion,
				Items AS ListaNotificaciones
			FROM CteTmp
			ORDER BY CteTmp.CategoriaNotificacionNombre ASC
			FOR JSON PATH
		) AS JsonSalida;
END
GO
