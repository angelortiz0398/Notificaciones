USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Contactos]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Contactos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[Email] [varchar](150) NULL,
	[Telefono] [varchar](20) NULL,
	[Puesto] [varchar](50) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cContacto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[Contactos] ON 

INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Valaentin', N'valentin@gmail.com', N'1111111111', N'Empleado', N'DEsarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Eduardo', N'eduardo@gmail.com', N'2222222222', N'Empleado', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Mario', N'mario@gmail.com', N'3333333333', N'Empleado', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Jose', N'jose@gmail.com', N'4444444444', N'Empleado', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Esteban', N'esteban@gmail.com', N'5555555555', N'Empleado', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Contactos] ([Id], [Nombre], [Email], [Telefono], [Puesto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'Roberto', N'robertogmail.com', N'6666666666', N'Empleado', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
SET IDENTITY_INSERT [Clientes].[Contactos] OFF
GO
