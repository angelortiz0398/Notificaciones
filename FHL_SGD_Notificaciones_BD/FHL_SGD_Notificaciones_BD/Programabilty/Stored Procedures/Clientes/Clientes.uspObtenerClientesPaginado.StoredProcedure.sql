USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerClientesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Clientes].[uspObtenerClientesPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Clientes.Clientes);
			END;
		
		;WITH CteTmp AS(
			Select 
			 [Clientes].[Id]
			  ,[RazonSocial]
			  ,[RFC]
			  ,[AxaptaId]
			  ,[Trail]
			
				From [Clientes].[Clientes] Clientes				
				WHERE	Clientes.Eliminado = 1 AND (@busqueda = '' OR Clientes.RazonSocial LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		-- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Clientes.Clientes WHERE Clientes.Eliminado = 1 AND (@busqueda = '' OR Clientes.RazonSocial LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;

		--SELECT
		--	(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
		--	(
		--		SELECT * FROM CteTmp
		--		ORDER BY CteTmp.Id ASC
		--						OFFSET (@pageIndex - 1) * @pageSize ROWS
		--		FETCH NEXT @pageSize ROWS ONLY
		--		FOR JSON PATH
		--	) AS JsonSalida;
end
GO
