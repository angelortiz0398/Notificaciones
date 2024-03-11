USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[CausasCambios]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[CausasCambios](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DescripcionCausa] [varchar](500) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CausasCambios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[CausasCambios] ON 

INSERT [Despachos].[CausasCambios] ([Id], [DescripcionCausa], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'No estaba', N'desarrollo', 1, CAST(N'2023-09-15T00:00:00.000' AS DateTime), N'{}')
INSERT [Despachos].[CausasCambios] ([Id], [DescripcionCausa], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'No localizado', N'desarrollo', 1, CAST(N'2023-09-22T00:00:00.000' AS DateTime), N'{}')
INSERT [Despachos].[CausasCambios] ([Id], [DescripcionCausa], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, NULL, NULL, NULL, NULL, N'')
SET IDENTITY_INSERT [Despachos].[CausasCambios] OFF
GO
