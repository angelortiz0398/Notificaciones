USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[ComentariosColaboradores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[ComentariosColaboradores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ColaboradoresId] [bigint] NOT NULL,
	[Fecha] [datetime] NULL,
	[Comentario] [varchar](1000) NULL,
	[ColaboradorRegId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_ComentariosColaboradores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[ColaboradoresId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Operadores].[ComentariosColaboradores] ON 

INSERT [Operadores].[ComentariosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Comentario], [ColaboradorRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 6, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'Comentario prueba', 7, N'usrPhoenixAdmin', 1, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
INSERT [Operadores].[ComentariosColaboradores] ([Id], [ColaboradoresId], [Fecha], [Comentario], [ColaboradorRegId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, 6, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'Comentario de PRUEBA 2', 7, N'usrPhoenixAdmin', 1, CAST(N'2024-01-08T14:01:43.407' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
SET IDENTITY_INSERT [Operadores].[ComentariosColaboradores] OFF
GO
ALTER TABLE [Operadores].[ComentariosColaboradores]  WITH NOCHECK ADD  CONSTRAINT [FK_ComentariosColaboradores_Colaboradores] FOREIGN KEY([ColaboradoresId])
REFERENCES [Operadores].[Colaboradores] ([Id])
GO
ALTER TABLE [Operadores].[ComentariosColaboradores] NOCHECK CONSTRAINT [FK_ComentariosColaboradores_Colaboradores]
GO
