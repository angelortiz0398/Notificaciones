USE [SGD_V1]
GO
/****** Object:  StoredProcedure [dbo].[uspObtenerAuxiliaresDespacho]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspObtenerAuxiliaresDespacho] 
	
AS
BEGIN
Declare @Json varchar(max);
DEclare @Manifiesto Varchar(Max);

 set @Json = (SELECT Auxiliares FROM Despachos.Despachos
WHERE FechaCreacion >= CAST(CAST(CURRENT_TIMESTAMP AS DATE) AS DATETIME)
	AND FechaCreacion < CAST(DATEADD(DAY, 1, CAST(CURRENT_TIMESTAMP AS DATE)) AS DATETIME) )

	--select @Json

	CREATE TABLE #TablaTmp (
	Llave bigint,
	Valor Varchar(200),
	)
	
	 INSERT INTO #TablaTmp(Llave,Valor,FolioDespacho)
	select * from OPENJSON(@Json)
		WITH
		(
			Valor Varchar(200),
			FolioDespacho varchar(200)
		)
	select * from #TablaTmp

	--update #TablaTmp set FolioDespacho = @Manifiesto

	select * from #TablaTmp AS JsonSalida FOR JSON PATH;
	END
GO
