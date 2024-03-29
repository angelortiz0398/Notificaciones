USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Vehiculos].[uspObtenerConfiguracionesVehiculosPaginado]    Script Date: 11/03/2024 02:11:12 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Vehiculos].[uspObtenerConfiguracionesVehiculosPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Vehiculos.Configuraciones);
			END;
		
		;WITH CteTmp AS(
			Select 
				[Configuraciones].Id
				,Nombre
				,[Trail]
			
				From Vehiculos.[Configuraciones] Configuraciones				
				WHERE	Configuraciones.Eliminado = 1 AND (@busqueda = '' OR Configuraciones.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Vehiculos.Configuraciones WHERE Configuraciones.Eliminado = 1 AND (@busqueda = '' OR Configuraciones.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
