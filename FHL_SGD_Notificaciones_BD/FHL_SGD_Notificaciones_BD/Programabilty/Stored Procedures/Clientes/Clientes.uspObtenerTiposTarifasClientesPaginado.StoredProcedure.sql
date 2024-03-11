USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[uspObtenerTiposTarifasClientesPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Clientes].[uspObtenerTiposTarifasClientesPaginado]
	@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(100) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM [Clientes].[TiposTarifasClientes]);
			END;
		
		;WITH CteTmp AS(
			SELECT Id
				  ,Nombre
				  ,IdInterno
				  ,TipoTarifaId
				  ,MonedaIdCosto
				  ,Costo
				  ,CostoNoArmada
				  ,CostoArmada
				  ,ValorMinimoArmada
				  ,TipoPesoId
				  ,TipoEmpaqueId
				  ,TipoVehiculoId
				  ,PrioridadId
				  ,ParadaIntermedia
				  ,Origen
				  ,Destino
				  ,PromesaEntrega
				  ,DiasEntregaId
				  ,MonedaIdGastoOperativoPermitido
				  ,GastoOperativoPermitido
				  ,MonedaIdCancelacionConManifiesto
				  ,CancelacionConManifiesto
				  ,MonedaIdCancelacionConBorrador
				  ,CancelacionConBorrador
				  ,MonedaIdCostoParadaIntermedia
				  ,CostoParadaIntermedia
				  ,MonedaIdCostoRetorno
				  ,CostoRetorno
				  ,TipoCustodia
				  ,Utilidad
				  ,ProveedorId
				  ,FechaVigenciaInicial
				  ,FechaVigenciaFinal
				  ,Usuario
				  ,Eliminado
				  ,FechaCreacion
				  ,Trail
			  FROM  [Clientes].[TiposTarifasClientes] TiposTarifasClientes
				------------------------------------------------------------------------------------
				WHERE TiposTarifasClientes.Eliminado = 1 AND (@busqueda = '' OR TiposTarifasClientes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
															OR CAST(TiposTarifasClientes.Costo AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
															OR CAST(TiposTarifasClientes.IdInterno AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM [Clientes].[TiposTarifasClientes] TiposTarifasClientes WHERE TiposTarifasClientes.Eliminado = 1 AND (@busqueda = '' OR TiposTarifasClientes.Nombre LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
													OR CAST(TiposTarifasClientes.Costo AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
													OR CAST(TiposTarifasClientes.IdInterno AS varchar(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%') 
													) AS TotalRows,
			(
				SELECT * FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
