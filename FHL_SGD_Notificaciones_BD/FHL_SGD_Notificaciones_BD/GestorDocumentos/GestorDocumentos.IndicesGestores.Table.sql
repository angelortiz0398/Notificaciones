USE [SGD_V1]
GO
/****** Object:  Table [GestorDocumentos].[IndicesGestores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GestorDocumentos].[IndicesGestores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Modulo] [varchar](150) NULL,
	[Referencia] [varchar](500) NULL,
	[FormatoDocumento] [varchar](50) NULL,
	[RutaInterna] [varchar](500) NULL,
	[RutaPublica] [varchar](500) NULL,
	[FechaCarga] [datetime] NULL,
	[Metodo] [varchar](150) NULL,
	[TipoDocumentoId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_IndicesGestores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [GestorDocumentos].[IndicesGestores]  WITH CHECK ADD  CONSTRAINT [FK_IndicesGestores_TiposDocuumentos] FOREIGN KEY([TipoDocumentoId])
REFERENCES [GestorDocumentos].[TiposDocumentos] ([Id])
GO
ALTER TABLE [GestorDocumentos].[IndicesGestores] CHECK CONSTRAINT [FK_IndicesGestores_TiposDocuumentos]
GO
