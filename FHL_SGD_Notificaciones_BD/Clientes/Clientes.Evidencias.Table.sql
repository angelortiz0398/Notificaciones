USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Evidencias]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Evidencias](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[TipoEvidencia] [int] NULL,
	[RequiereFoto] [bit] NULL,
	[RequiereVideo] [bit] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cEvidencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[Evidencias] ON 

INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Firma de quien entrega', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Fotografia de Carga', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Fotografia de quien entrega', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Fotografia de nota de entrega', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Fotografia de talon de embarque', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'Fotografia de factura con firma', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, N'Fotografia Factura con sello', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, N'Fotografia Guia de embarque', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (9, N'Fotografia pedimientos', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10, N'Fotografia identificacion de quien recibe', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Clientes].[Evidencias] ([Id], [Nombre], [TipoEvidencia], [RequiereFoto], [RequiereVideo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (11, N'Video', 1, NULL, NULL, N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
SET IDENTITY_INSERT [Clientes].[Evidencias] OFF
GO
