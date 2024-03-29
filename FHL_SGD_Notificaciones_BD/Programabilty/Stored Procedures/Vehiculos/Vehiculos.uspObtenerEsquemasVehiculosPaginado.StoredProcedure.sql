USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerEsquemasVehiculosPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Vehiculos].[uspObtenerEsquemasVehiculosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Vehiculos.Esquemas);
			END;
		
		;WITH CteTmp AS(
			Select 
				[Esquemas].Id
				,Nombre
				,[Trail]
			
				From Vehiculos.[Esquemas] Esquemas				
				WHERE	Esquemas.Eliminado = 1 AND (@busqueda = '' OR Esquemas.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM CteTmp ) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id DESC
							OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
end
GO
