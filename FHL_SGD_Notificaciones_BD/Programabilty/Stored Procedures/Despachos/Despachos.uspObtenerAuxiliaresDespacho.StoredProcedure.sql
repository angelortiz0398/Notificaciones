USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAuxiliaresDespacho]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAuxiliaresDespacho] 
	
AS
BEGIN
Declare @Json varchar(max);
DEclare @Manifiesto Varchar(Max);

 set @Json = (
SELECT D.FolioDespacho, A.Valor
FROM Despachos.Despachos D
Cross apply openjson (D.Auxiliares, '$')  with (Llave varchar(20) '$.Llave', Valor Varchar(200) '$.Valor') A
WHERE D.FechaCreacion >= CAST(CAST(CURRENT_TIMESTAMP AS DATE) AS DATETIME)
	AND D.FechaCreacion < CAST(DATEADD(DAY, 1, CAST(CURRENT_TIMESTAMP AS DATE)) AS DATETIME) FOR JSON PATH)


	CREATE TABLE #TablaTmp (
	FolioDespacho Varchar(MAX),
	Valor Varchar(max)
	)
	
	 INSERT INTO #TablaTmp(FolioDespacho,Valor)
	select * from  OPENJSON(@Json)
		WITH
		(
			FolioDespacho varchar(Max),
            Valor Varchar(MAx)

		)


		--Inicia la construccion del JSON
	SELECT (SELECT COUNT(*) FROM #TablaTmp) as TotalRows,
		(
		SELECT *
			FROM #TablaTmp
		FOR JSON AUTO) AS JsonSalida;
	
		END


GO
