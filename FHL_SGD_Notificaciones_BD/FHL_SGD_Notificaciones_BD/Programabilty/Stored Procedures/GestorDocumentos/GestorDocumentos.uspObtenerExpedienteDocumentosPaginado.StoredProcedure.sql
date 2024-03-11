USE [SGD_V1]
GO
/****** Object:  StoredProcedure [GestorDocumentos].[uspObtenerExpedienteDocumentosPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [GestorDocumentos].[uspObtenerExpedienteDocumentosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(300) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM GestorDocumentos.ExpedienteDocumentos);
			END;
		
		;WITH CteTmp AS(
			Select 
				[ExpedienteDocumentos].Id
			  ,ExpedienteDocumentos.[ExpedienteId]
			  ,ExpedienteDocumentos.[Expediente]
			  ,ExpedienteDocumentos.[TipoDocumentoId]
			  ,ExpedienteDocumentos.[TipoDocumento]
			  ,ExpedienteDocumentos.[Usuario]
			  ,ExpedienteDocumentos.[Eliminado]
			  ,ExpedienteDocumentos.[FechaCreacion]
			  ,ExpedienteDocumentos.[Trail]
			
				From GestorDocumentos.[ExpedienteDocumentos] ExpedienteDocumentos	
				INNER JOIN GestorDocumentos.Expedientes Expedientes on Expedientes.Id = ExpedienteDocumentos.ExpedienteId
				INNER JOIN GestorDocumentos.TiposDocumentos TiposDocumento on ExpedienteDocumentos.TipoDocumentoId = TiposDocumento.Id
				WHERE	ExpedienteDocumentos.Eliminado = 1 AND (@busqueda = '' OR ExpedienteDocumentos.Expediente LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
																				OR Expedientes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
																				OR TiposDocumento.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				--ORDER BY Id DESC
				--OFFSET (@pageIndex - 1) * @pageSize ROWS
				--FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		--SELECT
		--	(SELECT COUNT(*) FROM GestorDocumentos.ExpedienteDocumentos WHERE ExpedienteDocumentos.Eliminado = 1 AND (@busqueda = '' OR ExpedienteDocumentos.Expediente LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
		--	(
		--		SELECT CteTmp.*
		--		FROM CteTmp
		--		FOR JSON PATH
		--	) AS JsonSalida;


		SELECT
			(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
								OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;

end
GO
