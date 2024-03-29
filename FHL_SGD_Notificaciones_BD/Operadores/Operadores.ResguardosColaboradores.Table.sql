USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[ResguardosColaboradores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[ResguardosColaboradores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ColaboradoresId] [bigint] NOT NULL,
	[Fecha] [datetime] NULL,
	[Articulo] [varchar](500) NULL,
	[ColaboradoresRegId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_ResguardosColaboradores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[ColaboradoresId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Operadores].[ResguardosColaboradores] ON 

INSERT [Operadores].[ResguardosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Articulo], [ColaboradoresRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 6, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'Articulo BASE', 7, N'usrPhoenixAdmin', 1, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
INSERT [Operadores].[ResguardosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Articulo], [ColaboradoresRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, 6, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'Articulo base 2', 7, N'usrPhoenixAdmin', 1, CAST(N'2024-01-08T14:21:50.547' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
INSERT [Operadores].[ResguardosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Articulo], [ColaboradoresRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, 6, CAST(N'2024-03-06T00:00:00.000' AS DateTime), N'zxcvcv', NULL, N'UsrPhoenixAdmin', 0, CAST(N'2024-03-06T14:35:38.780' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-03-06T14:35:19.5906312-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-06T14:35:19.5906312-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-06T14:35:53.3947863-06:00"}]')
INSERT [Operadores].[ResguardosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Articulo], [ColaboradoresRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, 1728, CAST(N'2024-03-06T00:00:00.000' AS DateTime), N'sdf pruebawse', NULL, N'UsrPhoenixAdmin', 0, CAST(N'2024-03-06T14:36:42.157' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-03-06T14:36:27.1099055-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-06T14:36:27.1099055-06:00"}]')
SET IDENTITY_INSERT [Operadores].[ResguardosColaboradores] OFF
GO
ALTER TABLE [Operadores].[ResguardosColaboradores]  WITH NOCHECK ADD  CONSTRAINT [FK_ResguardosColaboradores_Colaboradores] FOREIGN KEY([ColaboradoresId])
REFERENCES [Operadores].[Colaboradores] ([Id])
GO
ALTER TABLE [Operadores].[ResguardosColaboradores] NOCHECK CONSTRAINT [FK_ResguardosColaboradores_Colaboradores]
GO
