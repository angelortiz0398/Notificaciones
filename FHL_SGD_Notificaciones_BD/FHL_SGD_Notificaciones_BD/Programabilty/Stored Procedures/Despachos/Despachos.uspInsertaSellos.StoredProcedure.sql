USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Despachos].[uspInsertaSellos]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Despachos].[uspInsertaSellos] 
@Json varchar(max)

AS
BEGIN

select @Json

create table #TablaTmp(
NumeroSello varchar(50),
DespachoId varchar(max),
Usuario varchar(200),
Trail varchar(max),
RegistroNuevo bit default 1
)

insert into #TablaTmp(NumeroSello,DespachoId,Usuario,Trail)
select NumeroSello,DespachoId,Usuario,Trail  from OPENJSON(@Json)
WITH( 
Id VARCHAR(20) '$.Id' ,
CurrentData nvarchar(MAX)  '$.CurrentData' AS JSON)
CROSS APPLY OPENJSON(CurrentData) WITH (
NumeroSello VARCHAR(20) '$.NumeroSello', DespachoId varchar(50) '$.DespachoId', Usuario varchar(200) '$.Usuario', Trail varchar(max) '$.Trail') 

update #TablaTmp set RegistroNuevo = 0
from #TablaTmp
Join Despachos.Sellos on #TablaTmp.NumeroSello = Despachos.Sellos.Sello

select * from  #TablaTmp

insert into Despachos.Sellos(DespachoId,Sello,Usuario,Eliminado,FechaCreacion,Trail)
select
DespachoId,
NumeroSello,
Usuario,
1,
CURRENT_TIMESTAMP,
Trail
from #TablaTmp
		where RegistroNuevo = 1;


END
GO
