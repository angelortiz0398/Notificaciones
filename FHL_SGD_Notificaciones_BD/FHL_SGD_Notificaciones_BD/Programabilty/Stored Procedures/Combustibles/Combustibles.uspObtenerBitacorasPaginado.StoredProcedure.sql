USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Combustibles].[uspObtenerBitacorasPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		NewlandApps
-- Create date: Julio de 2023
-- Description:	Obtiene la información del catálogo de BitacoraCombustible activos en un formato Json así como la información de elementos ligados a la misma
-- =============================================

CREATE PROCEDURE [Combustibles].[uspObtenerBitacorasPaginado] 
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
			SET @pageSize = (SELECT MAX(Id) FROM BitacorasCombustibles);
		END;

	--Obtiene la información de las bitacoras y la conviernte en un formato JSON
    ;WITH CteTmp AS(
                SELECT BitacorasCombustiblesTabla.[Id]
                    ,BitacorasCombustiblesTabla.[FechaRegistro]
                    ,BitacorasCombustiblesTabla.[FechaCarga]
                    ,BitacorasCombustiblesTabla.[Combustible]
                    ,BitacorasCombustiblesTabla.[Factura]
                    ,BitacorasCombustiblesTabla.[OdometroActual]
                    ,BitacorasCombustiblesTabla.[OdometroAnterior]
                    ,BitacorasCombustiblesTabla.[Litros]
                    ,BitacorasCombustiblesTabla.[Costo]
                    ,BitacorasCombustiblesTabla.[RendimientoCalculado]
                    ,BitacorasCombustiblesTabla.[CostoTotal]
                    ,BitacorasCombustiblesTabla.[IVA]
                    ,BitacorasCombustiblesTabla.[IEPS]
                    ,BitacorasCombustiblesTabla.[Comentario]
                    ,BitacorasCombustiblesTabla.[Duracion]
                    ,BitacorasCombustiblesTabla.[Referencia]
                    ,BitacorasCombustiblesTabla.[VehiculosId]
                    ,BitacorasCombustiblesTabla.[TiposCombustiblesId]
                    ,BitacorasCombustiblesTabla.[EstacionesId]
                    ,BitacorasCombustiblesTabla.[ColaboradoresId]
                    ,BitacorasCombustiblesTabla.[Usuario]
                    ,BitacorasCombustiblesTabla.[Eliminado]
                    ,BitacorasCombustiblesTabla.[FechaCreacion]
                    ,BitacorasCombustiblesTabla.[Trail]

                    --Tablas relacionadas con la bitacora
                    ,JSON_QUERY((SELECT Vehiculos.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Vehiculos
                    ,JSON_QUERY((SELECT TiposCombustibles.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS TiposCombustibles
                    ,JSON_QUERY((SELECT Estaciones.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Estaciones
                    ,JSON_QUERY((SELECT Colaboradores.* FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS Colaboradores

                FROM  [Combustibles].[BitacorasCombustibles] BitacorasCombustiblesTabla
                        INNER JOIN Vehiculos.Vehiculos Vehiculos ON Vehiculos.Id = BitacorasCombustiblesTabla.VehiculosId
                        INNER JOIN Combustibles.TiposCombustibles TiposCombustibles ON TiposCombustibles.Id = BitacorasCombustiblesTabla.TiposCombustiblesId
                        INNER JOIN Combustibles.Estaciones Estaciones ON Estaciones.Id = BitacorasCombustiblesTabla.EstacionesId
                        INNER JOIN Operadores.Colaboradores Colaboradores ON Colaboradores.Id = BitacorasCombustiblesTabla.ColaboradoresId
                WHERE BitacorasCombustiblesTabla.Eliminado = 1 AND (@busqueda = '' OR BitacorasCombustiblesTabla.Factura LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
    )
	-- Obtiene la información de los vehículos y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM CteTmp) AS TotalRows,
			(
				SELECT * FROM CteTmp
				ORDER BY CteTmp.Id ASC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
				FOR JSON PATH
			) AS JsonSalida;
END
GO
