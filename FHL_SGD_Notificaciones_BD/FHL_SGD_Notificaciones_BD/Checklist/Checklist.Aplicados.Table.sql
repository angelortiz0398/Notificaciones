USE [SGD_V1]
GO
/****** Object:  Table [Checklist].[Aplicados]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Checklist].[Aplicados](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CheckListId] [bigint] NOT NULL,
	[VehiculoId] [bigint] NOT NULL,
	[DespachoId] [bigint] NULL,
	[FechaAplicado] [datetime] NULL,
	[JsonRespuestas] [varchar](max) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Aplicados] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[CheckListId] ASC,
	[VehiculoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
