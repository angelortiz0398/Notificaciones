USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerVisoresPaginado]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerVisoresPaginado]

@pageIndex         int = 1,
	@pageSize		   int = 10,
	@busqueda			varchar(300) = ''
as
Begin
	--No regresar dato de filas afectadas
		SET NOCOUNT ON;
		IF @pageSize = 0
			BEGIN
			  SET @pageSize = (SELECT MAX(Id) FROM Despachos.Visores);
			END;
		
		;WITH CteTmp AS(
			Select 
				[Visores].Id
				,[Manifiesto]
				,[ClienteId]
				,[Cliente]
				,[Custodia]
				,[Operador]
				,[Vehiculo]
				,[Placa]
				,[Economico]
				,[Origen]
				,[Destino]
				,[VentanaAtencionInicio]
				,[VentanaAtencionFin]
				,[Estatus]
				,[ManifiestoId]
				,[Ticket]
				,[TiempoRestante]
				,[UbicacionActual]
				,[TipoEntregaId]
				,[PrioridadId]
				,[Reintentos]
				,[Restantes]
				,[Ubicacion]
				,[DiasLaborados]
				,[UltimoServicio]
				,[DiasTranscurridos]
				,[HorasDetenido]
				,[CostoFlete]
				,[GastosOperativos]
				,[GastosIndirectos]
				,[GastosNoJustificados]
				,[UltimoMovimientoGPS]
				,[DistanciaRuta]
				,[DistanciaRealizada]
				,[FechaCargaEstimada]
				,[FechaCarga]
				,[FechaSalidaEstimada]
				,[FechaSalida]
				,[FechaPromesaLlegada]
				,[FechaLlegada]
				,[FechaPromesaRetorno]
				,[FechaRetorno]
				,[FechaCreacionViaje]
				,[EtaDestino]
				,[EtaRetorno]
				,[Usuario]
				,[Eliminado]
				,[FechaCreacion]
				,[Trail]
			
				From Despachos.[Visores] Visores				
				WHERE	Visores.Eliminado = 1 AND (@busqueda = '' OR Visores.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
							OR CAST(Visores.Cliente AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
							OR CAST(Visores.Vehiculo AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
							OR CAST(Visores.Placa AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
							OR CAST(Visores.Economico AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
				ORDER BY Id DESC
				OFFSET (@pageIndex - 1) * @pageSize ROWS
				FETCH NEXT @pageSize ROWS ONLY
		)

		---- Obtiene la información de los tickets y la convierte en un formato JSON
		SELECT
			(SELECT COUNT(*) FROM Despachos.Visores WHERE Visores.Eliminado = 1 AND (@busqueda = '' OR Visores.Manifiesto LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
									OR CAST(Visores.Cliente AS VARCHAR(50)) LIKE'%' + LTRIM(RTRIM(@busqueda)) + '%'
									OR CAST(Visores.Cliente AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
									
									OR CAST(Visores.Vehiculo AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
									OR CAST(Visores.Placa AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%'
									OR CAST(Visores.Economico AS VARCHAR(50)) LIKE '%' + LTRIM(RTRIM(@busqueda)) + '%')
									) AS TotalRows,
			(
				SELECT CteTmp.*
				FROM CteTmp
				FOR JSON PATH
			) AS JsonSalida;
end
GO
