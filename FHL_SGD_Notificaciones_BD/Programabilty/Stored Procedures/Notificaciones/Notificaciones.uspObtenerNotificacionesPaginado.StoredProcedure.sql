USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerNotificacionesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Notificaciones].[uspObtenerNotificacionesPaginado]
@pageIndex		int = 1,
@pageSize		int = 0,
@busqueda		varchar(100) = ''
AS
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize =0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM [Notificaciones]);
	END;
	--Obtener informacion de Incidencias y convertilas a json
	;WITH NotificacionTmp AS
						(
							SELECT [NotificacionesTabla].[Id]
							  ,[NotificacionesTabla].[CategoriasNotificacionesId]
							  ,[NotificacionesTabla].[Nombre]
							  ,[NotificacionesTabla].[Activada]
							  ,[NotificacionesTabla].[Condiciones]
							  ,[NotificacionesTabla].[ListaContactos]
							  ,[NotificacionesTabla].[Reglas]
							  ,[NotificacionesTabla].[NotificarPorId]
							  ,[NotificacionesTabla].[Usuario]
							  ,[NotificacionesTabla].[Eliminado]
							  ,[NotificacionesTabla].[FechaCreacion]
							  ,[NotificacionesTabla].[Trail]
								  							  
						
	FROM [Notificaciones].[Notificaciones] NotificacionesTabla
	WHERE NotificacionesTabla.Eliminado = 1 
	ORDER BY Id ASC
	OFFSET (@pageIndex - 1) * @pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY
		)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM [Notificaciones] WHERE [Notificaciones].Eliminado = 1)AS TotalRows,
			(	
				SELECT * FROM NotificacionTmp	
				ORDER BY NotificacionTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
end
GO
