USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[Operadores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[Operadores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[Default] [bit] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Operadores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Despachos].[Operadores]  WITH NOCHECK ADD  CONSTRAINT [FK_Operadores_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[Operadores] NOCHECK CONSTRAINT [FK_Operadores_Despachos]
GO
