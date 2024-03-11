USE [SGD_V1]
GO
/****** Object:  Table [Vehiculos].[Grupos]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vehiculos].[Grupos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](300) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Grupos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Vehiculos].[Grupos] ON 

INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Grupo 1 de pruebas', N'usrPhoenixAdmin', 1, CAST(N'2023-06-29T16:27:24.330' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-18T12:06:26.1679533-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-18T12:06:26.1679533-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-18T12:06:26.1679533-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-18T12:06:26.1679533-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Grupo 2 de pruebas', N'Desarrollo', 1, CAST(N'2023-06-29T16:27:29.140' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Grupo 3 de pruebas', N'Desarrollo', 1, CAST(N'2023-06-29T16:27:53.637' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Grupo 4 de pruebas', N'Desarrollo', 1, CAST(N'2023-06-29T16:28:00.043' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Grupo 5 de pruebas', N'Desarrollo', 1, CAST(N'2023-06-29T16:28:05.097' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'Grupo 6 de pruebas', N'Desarrollo', 1, CAST(N'2024-01-08T14:48:43.437' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, N'Grupo 7 de PRUEBAS', N'Desarrollo', 1, CAST(N'2024-01-08T14:48:55.963' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-09-26T17:20:21.5057212-06:00"}]')
INSERT [Vehiculos].[Grupos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, N'test ', N'usrPhoenixAdmin', 1, CAST(N'2024-01-22T12:45:17.650' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-01-22T12:40:15.0188085-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-22T12:40:15.0188085-06:00"}]')
SET IDENTITY_INSERT [Vehiculos].[Grupos] OFF
GO
