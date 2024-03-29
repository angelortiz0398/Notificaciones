USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[RegistroAjuste]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[RegistroAjuste](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[ColaboradorId] [bigint] NOT NULL,
	[MonedaIdMonto] [int] NOT NULL,
	[Monto] [numeric](18, 2) NULL,
	[MetodoId] [int] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_RegistroAjuste] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC,
	[ColaboradorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Despachos].[RegistroAjuste]  WITH CHECK ADD  CONSTRAINT [FK_RegistroAjuste_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[RegistroAjuste] CHECK CONSTRAINT [FK_RegistroAjuste_Despachos]
GO
