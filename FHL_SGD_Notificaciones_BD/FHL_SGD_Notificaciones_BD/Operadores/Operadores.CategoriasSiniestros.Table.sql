USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[CategoriasSiniestros]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[CategoriasSiniestros](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CategoriasSiniestros] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Operadores].[CategoriasSiniestros] ON 

INSERT [Operadores].[CategoriasSiniestros] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Golpe frontal', N'Desarrollo', 1, CAST(N'2023-06-13T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
INSERT [Operadores].[CategoriasSiniestros] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Golpe Lateral', N'Desarrollo', 1, CAST(N'2024-01-08T13:49:31.720' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
INSERT [Operadores].[CategoriasSiniestros] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Golpe Interior', N'Desarrollo', 1, CAST(N'2024-01-08T16:35:55.653' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
SET IDENTITY_INSERT [Operadores].[CategoriasSiniestros] OFF
GO
