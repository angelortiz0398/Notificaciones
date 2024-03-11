USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[HabilidadesColaboradores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[HabilidadesColaboradores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_HabilidadesColaboradores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Operadores].[HabilidadesColaboradores] ON 

INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Habilidad 1', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Habilidad 2', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Habilidad 3', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Habilidad 4', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Habilidad 5', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'Habilidad 6', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, N'Habilidad 7', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, N'HABILIDAD 8', N'Desarrollo', 1, CAST(N'2023-04-18T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Operadores].[HabilidadesColaboradores] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (9, N'HABILIDAD 9', N'Desarrollo', 1, CAST(N'2024-01-08T14:09:31.827' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
SET IDENTITY_INSERT [Operadores].[HabilidadesColaboradores] OFF
GO
