USE [SGD_V1]
GO
/****** Object:  Table [dbo].[Tablatemp]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tablatemp](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[RFC] [varchar](13) NULL,
	[Identificacion] [varchar](20) NULL,
	[TipoPerfilesId] [bigint] NULL,
	[CentroDistribucionesId] [bigint] NULL,
	[NSS] [varchar](30) NULL,
	[CorreoElectronico] [varchar](150) NULL,
	[Telefono] [varchar](15) NULL,
	[IMEI] [varchar](20) NULL,
	[Habilidades] [varchar](2000) NULL,
	[TipoVehiculo] [varchar](2000) NULL,
	[Estado] [bit] NULL,
	[Comentarios] [varchar](1000) NULL,
	[UltimoAcceso] [datetime] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
