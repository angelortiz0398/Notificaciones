USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[TiposTarifas]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[TiposTarifas](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cTipoTarifa] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[TiposTarifas] ON 

INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Tipo de vehículo', N'Desarrollo', 1, CAST(N'2023-04-19T00:00:00.000' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Empaque', N'Desarrollo', 1, CAST(N'2023-04-19T14:45:31.840' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Ruta', N'Desarrollo', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Litros', N'Desarrollo', 1, CAST(N'2024-04-24T00:00:00.000' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Peso', N'Desarrollo', 1, CAST(N'2024-04-24T00:00:00.000' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
INSERT [Clientes].[TiposTarifas] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'Hand-Carry', N'Desarrollo', 1, CAST(N'2023-04-24T00:00:00.000' AS DateTime), N'[{"trail_system_user":"valentinbaltazar","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-06-08T13:09:23.130842-06:00"}]')
SET IDENTITY_INSERT [Clientes].[TiposTarifas] OFF
GO
