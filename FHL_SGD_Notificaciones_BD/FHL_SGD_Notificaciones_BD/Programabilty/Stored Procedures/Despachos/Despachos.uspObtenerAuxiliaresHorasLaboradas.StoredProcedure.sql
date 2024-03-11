USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspObtenerAuxiliaresHorasLaboradas]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Despachos].[uspObtenerAuxiliaresHorasLaboradas] 
	
AS
BEGIN
Declare @Json varchar(max);

 set @Json = (
SELECT D.FolioDespacho, A.Valor, DV.DiasLaborados
FROM Despachos.Despachos D
left join Despachos.Visores DV
on DV.Manifiesto = FolioDespacho
Cross apply openjson (D.Auxiliares, '$')  with (Llave varchar(20) '$.Llave', Valor Varchar(200) '$.Valor') A
where D.FechaCreacion >= DATEADD(DAY, -7, CURRENT_TIMESTAMP)
and D.FechaCreacion <= CURRENT_TIMESTAMP
order by DV.DiasLaborados asc FOR JSON PATH)


	CREATE TABLE #TablaTmp (
	FolioDespacho Varchar(MAX),
	Valor Varchar(max),
	DiasLaborados int
	)
	
	 INSERT INTO #TablaTmp(FolioDespacho,Valor,DiasLaborados)
	select * from  OPENJSON(@Json)
		WITH
		(
			FolioDespacho varchar(Max),
            Valor Varchar(MAx),
			DiasLaborados int
		)


		--Inicia la construccion del JSON
	SELECT (SELECT COUNT(*) FROM #TablaTmp) as TotalRows,
		(
		SELECT *
			FROM #TablaTmp
		FOR JSON AUTO) AS JsonSalida;
	
		END


GO
