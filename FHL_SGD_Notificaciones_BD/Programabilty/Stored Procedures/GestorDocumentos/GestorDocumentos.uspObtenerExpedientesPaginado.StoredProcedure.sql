USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GestorDocumentos].[uspObtenerExpedientesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [GestorDocumentos].[uspObtenerExpedientesPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM GestorDocumentos.Expedientes);
			END;
		
		;WITH CteTmp AS(
			Select 
				[Expedientes].Nombre
			  ,[ReferenciaId]
			  ,[ConfiguracionId]
			  ,[ExpedienteDocumentos]
			  ,[Trail]
			
				From GestorDocumentos.[Expedientes] Expedientes				
				WHERE	Expedientes.Eliminado = 1 AND (@busqueda = '' OR Expedientes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM GestorDocumentos.Expedientes WHERE Expedientes.Eliminado = 1 AND (@busqueda = '' OR Expedientes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
