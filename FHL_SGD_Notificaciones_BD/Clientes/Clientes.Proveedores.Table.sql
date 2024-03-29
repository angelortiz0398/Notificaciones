USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Proveedores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Proveedores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[TipoServicioId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cProveedores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[Proveedores] ON 

INSERT [Clientes].[Proveedores] ([Id], [Nombre], [TipoServicioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Gamesa', 1, N'Desarrollo', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N' ')
INSERT [Clientes].[Proveedores] ([Id], [Nombre], [TipoServicioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Jumex', 1, N'Desarrollo', 1, CAST(N'2023-06-09T00:00:00.000' AS DateTime), N' ')
INSERT [Clientes].[Proveedores] ([Id], [Nombre], [TipoServicioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Acer', 1, N'Desarrollo', 1, CAST(N'2023-06-09T00:00:00.000' AS DateTime), N' ')
SET IDENTITY_INSERT [Clientes].[Proveedores] OFF
GO
ALTER TABLE [Clientes].[Proveedores]  WITH CHECK ADD  CONSTRAINT [FK_Proveedores_TiposServicios] FOREIGN KEY([TipoServicioId])
REFERENCES [Clientes].[TiposServicios] ([Id])
GO
ALTER TABLE [Clientes].[Proveedores] CHECK CONSTRAINT [FK_Proveedores_TiposServicios]
GO
