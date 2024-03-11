USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Notificaciones].[uspObtenerAlertasPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Notificaciones].[uspObtenerAlertasPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
AS
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize =0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM [Alertas]);
	END;
	--Obtener informacion de Incidencias y convertilas a json
	;WITH AlertaTmp AS
						(
							SELECT AlertasTabla.[Id]
								  ,AlertasTabla.[FechaCreacionAlerta]
								  ,AlertasTabla.[NotificacionesId]
								  ,AlertasTabla.[TextoAlerta]
								  ,AlertasTabla.[Usuario]
								  ,AlertasTabla.[Eliminado]
								  ,AlertasTabla.[FechaCreacion]
								  ,AlertasTabla.[Trail]
								  							  
						
	FROM [Notificaciones].[Alertas] AlertasTabla
	WHERE AlertasTabla.Eliminado = 1 

	ORDER BY Id ASC
	OFFSET (@pageIndex - 1) * @pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY
		)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM [Alertas] WHERE [Alertas].Eliminado = 1)AS TotalRows,
			(	
				SELECT * FROM AlertaTmp	
				ORDER BY AlertaTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
end
GO
