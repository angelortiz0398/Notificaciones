USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[PrioridadesTickets]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[PrioridadesTickets](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Prioridad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[PrioridadesTickets] ON 

INSERT [Despachos].[PrioridadesTickets] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Normal', N'usrPhoenixAdmin', 1, CAST(N'2024-03-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-09-19T12:28:36.7259452-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T11:09:29.9601841-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T11:38:25.4705799-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T14:25:27.8635768-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T16:17:59.3968536-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T17:04:03.268366-06:00"}]')
INSERT [Despachos].[PrioridadesTickets] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Urgente', N'usrPhoenixAdmin', 1, CAST(N'2024-03-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-09-19T12:28:36.7259452-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T11:09:29.9601841-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T11:38:25.4705799-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T14:25:27.8635768-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T16:17:59.3968536-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-21T17:04:03.268366-06:00"}]')
SET IDENTITY_INSERT [Despachos].[PrioridadesTickets] OFF
GO
