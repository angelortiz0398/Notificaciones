USE [SGD_V1]
GO
/****** Object:  StoredProcedure [Clientes].[PruebasSelect]    Script Date: 11/03/2024 02:11:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Clientes].[PruebasSelect]
	
AS
BEGIN
Select * from CLientes.Clientes
Select * from Despachos.Visores
Select * from Productos.PRoductos
END
GO
