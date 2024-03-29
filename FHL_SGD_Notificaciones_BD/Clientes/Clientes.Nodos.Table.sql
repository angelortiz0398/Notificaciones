USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Nodos]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Nodos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](1000) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_cNodos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[Nodos] ON 

INSERT [Clientes].[Nodos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'CEDIS Monterrey', N'Desarrollo', 1, CAST(N'2023-05-17T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-09-26T13:06:48.787901-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-26T14:57:59.6270664-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-25T11:49:18.3433841-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-21T17:22:05.2513252-06:00"}]')
INSERT [Clientes].[Nodos] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Plaza Antara', N'Desarrollo', 1, CAST(N'2023-05-17T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-09-26T13:06:48.787901-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-26T14:57:59.6270664-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-25T11:49:18.3433841-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-21T17:22:05.2513252-06:00"}]')
SET IDENTITY_INSERT [Clientes].[Nodos] OFF
GO
