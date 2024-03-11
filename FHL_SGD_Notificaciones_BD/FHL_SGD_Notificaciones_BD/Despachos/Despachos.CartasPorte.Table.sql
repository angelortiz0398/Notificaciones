USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[CartasPorte]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[CartasPorte](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[FolioCarta] [varchar](50) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CartasPorte] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Despachos].[CartasPorte]  WITH CHECK ADD  CONSTRAINT [FK_CartasPorte_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[CartasPorte] CHECK CONSTRAINT [FK_CartasPorte_Despachos]
GO
