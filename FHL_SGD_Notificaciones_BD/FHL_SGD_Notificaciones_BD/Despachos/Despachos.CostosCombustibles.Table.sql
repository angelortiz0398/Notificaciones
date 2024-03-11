USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[CostosCombustibles]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[CostosCombustibles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TipoCombustibleId] [bigint] NULL,
	[Monto] [numeric](18, 2) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CostosCombustibles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Despachos].[CostosCombustibles]  WITH CHECK ADD  CONSTRAINT [FK_CostosCombustibles_TiposCombustibles] FOREIGN KEY([TipoCombustibleId])
REFERENCES [Combustibles].[TiposCombustibles] ([Id])
GO
ALTER TABLE [Despachos].[CostosCombustibles] CHECK CONSTRAINT [FK_CostosCombustibles_TiposCombustibles]
GO
