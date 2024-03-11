USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[DespachosExpress]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[DespachosExpress](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VehiculoId] [bigint] NOT NULL,
	[ColaboradorId] [bigint] NOT NULL,
	[Auxiliares] [varchar](5000) NULL,
	[FecInicial] [datetime] NULL,
	[FecFinal] [datetime] NULL,
	[OrigenId] [bigint] NULL,
	[DestinoId] [bigint] NULL,
	[Referencia] [varchar](1500) NULL,
	[Efectividad] [int] NULL,
	[Distancia] [int] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_DespachosExpress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[VehiculoId] ASC,
	[ColaboradorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
