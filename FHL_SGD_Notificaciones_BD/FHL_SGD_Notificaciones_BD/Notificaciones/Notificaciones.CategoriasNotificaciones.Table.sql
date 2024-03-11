USE [SGD_V1]
GO
/****** Object:  Table [Notificaciones].[CategoriasNotificaciones]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Notificaciones].[CategoriasNotificaciones](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CategoriasNotificaciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Notificaciones].[CategoriasNotificaciones] ON 

INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Custodias', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Colaborador', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Combustible', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Clientes', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Gastos operativos', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'GPS', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, N'Manifiesto', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, N'Remolque', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
INSERT [Notificaciones].[CategoriasNotificaciones] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (9, N'Vehículo', N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T10:34:04.510' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-47BG2KH","trail_notes":"Alta de registro","trail_timemark":2023-08-30T10:34:04.510}]')
SET IDENTITY_INSERT [Notificaciones].[CategoriasNotificaciones] OFF
GO
