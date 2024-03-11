USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerCustodiasPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de Custodias activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Clientes].[uspObtenerCustodiasPaginado] 
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda          varchar(100)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @pageSize = 0
		BEGIN
			SET @pageSize = (SELECT MAX(Id) FROM Custodias);
		END;

	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT CustodiasTabla.[Id]
                    ,CustodiasTabla.[Nombre]
                    ,CustodiasTabla.[TipoTarifa]
                    ,CustodiasTabla.[MonedaIdCosto]
                    ,CustodiasTabla.[Costo]
                    ,CustodiasTabla.[MonedaIdCostoArmada]
                    ,CustodiasTabla.[CostoArmada]
                    ,CustodiasTabla.[MonedaIdCostoNoArmada]
                    ,CustodiasTabla.[CostoNoArmada]
                    ,CustodiasTabla.[MonedaIdValorMinimo]
                    ,CustodiasTabla.[ValorMinimoArmada]
                    ,CustodiasTabla.[Origen]
                    ,CustodiasTabla.[Destino]
                    ,CustodiasTabla.[TipoCustodia]
                    ,CustodiasTabla.[Utilidad]
                    ,CustodiasTabla.[ProveedorId]                    
                    ,CustodiasTabla.[Usuario]
                    ,CustodiasTabla.[Eliminado]
                    ,CustodiasTabla.[FechaCreacion]
                    ,CustodiasTabla.[Trail]

					--Tablas relacionadas
					,JSON_QUERY((SELECT TipoCustodia.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TipoCustodiaObj
					,JSON_QUERY((SELECT Proveedor.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Proveedor

                FROM  [Clientes].[Custodias] CustodiasTabla
				INNER JOIN Despachos.TiposCustodias TipoCustodia ON TipoCustodia.Id = CustodiasTabla.TipoCustodia
				INNER JOIN Clientes.Proveedores Proveedor ON Proveedor.Id = CustodiasTabla.ProveedorId

                WHERE CustodiasTabla.Eliminado = 1 AND (@busqueda = '' OR CustodiasTabla.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')

				ORDER BY Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
    )
	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Custodias WHERE Custodias.Eliminado = 1 AND (@busqueda = '' OR Custodias.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
				FOR JSON PATH
			) AS JsonSalida;
END
GO
