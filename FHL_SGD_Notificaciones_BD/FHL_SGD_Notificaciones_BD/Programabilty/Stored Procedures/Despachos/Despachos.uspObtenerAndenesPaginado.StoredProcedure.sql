USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAndenesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Despachos].[uspObtenerAndenesPaginado]
@pageIndex		int = 1,
@pageSize		int = 10,
@busqueda		varchar(100) = ''
as
BEGIN
-- No regresa la informacion de las filas afectadas
SET NOCOUNT ON;
IF @pageSize = 0
	BEGIN 
		SET @pageSize = (SELECT MAX(Id) FROM Andenes);
	END;
	--Obtener informacion de Andenes y convertilas a json
	;WITH AndenTmp AS
						(
							SELECT AndenesTabla.[Id]
								  ,AndenesTabla.[Nombre]
								  --,AndenesTabla.[CentroDistribucionId] => Un join a la tabla correspondiente para recuperar el valor
								  --,AndenesTabla.[ColaboradorId] => Un join a la tabla correspondiente para recuperar el valor
								  ,AndenesTabla.[AndenCortina]
								  ,AndenesTabla.[CodigoAnden]
								  ,AndenesTabla.[Usuario]
								  ,AndenesTabla.[Eliminado]
								  ,AndenesTabla.[FechaCreacion]
								  ,AndenesTabla.[Trail],

								  ------- Tablas relacionadas con el modelo
					    		AndenesTabla.CedisID,
								JSON_QUERY((SELECT LTRIM(RTRIM(CentrosDistribuciones.Nombre)) AS Nombre FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Cedis

								FROM [Despachos].[Andenes] AndenesTabla
-------- Creacion de JOINS
LEFT JOIN Operadores.CentrosDistribuciones ON CentrosDistribuciones.Id = AndenesTabla.CedisID
WHERE AndenesTabla.Eliminado = 1 AND (@busqueda = '' OR AndenesTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' OR AndenesTabla.CodigoAnden LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

ORDER BY Id ASC
OFFSET (@pageIndex - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
	)

	-- Obtener los registros como JSON
	SELECT 
			(SELECT COUNT(*) FROM Andenes WHERE Andenes.Eliminado = 1 AND (@busqueda = '' OR Andenes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'  OR Andenes.CodigoAnden LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%' ))AS TotalRows,
			(	
				SELECT * FROM AndenTmp	
				ORDER BY AndenTmp.Id ASC
				FOR JSON PATH
			)AS JsonSalida;
END
GO
