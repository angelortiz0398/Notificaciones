USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[TiposVehiculos]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[TiposVehiculos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cTipoVehiculo] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[TiposVehiculos] ON 

INSERT [Clientes].[TiposVehiculos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Sprinter Larga', N'Desarrollo ', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N'{}')
INSERT [Clientes].[TiposVehiculos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Sprinter Corta', N'Desarrollo', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N'{}')
INSERT [Clientes].[TiposVehiculos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Sprinter Extra Larga', N'Desarrollo', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N'{}')
INSERT [Clientes].[TiposVehiculos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'string', N'string', 0, CAST(N'2023-06-27T13:42:19.227' AS DateTime), N'string')
SET IDENTITY_INSERT [Clientes].[TiposVehiculos] OFF
GO
