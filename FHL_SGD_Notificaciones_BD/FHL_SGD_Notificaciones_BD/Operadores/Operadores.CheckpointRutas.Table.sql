USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[CheckpointRutas]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[CheckpointRutas](
	[Id] [bigint] NOT NULL,
	[RutaId] [bigint] NOT NULL,
	[CheckPointId] [bigint] NOT NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CheckpointRutas] PRIMARY KEY CLUSTERED 
(
	[RutaId] ASC,
	[CheckPointId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [Operadores].[CheckpointRutas] ([Id], [RutaId], [CheckPointId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 1, 2, N'usrPheonixAdmin', 1, CAST(N'2024-01-08T00:00:00.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-31T09:50:17.94489-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:13:11.5217107-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-31T10:16:20.16915-06:00"}]')
GO
ALTER TABLE [Operadores].[CheckpointRutas]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointRutas_CheckPoint] FOREIGN KEY([CheckPointId])
REFERENCES [Operadores].[CheckPoint] ([Id])
GO
ALTER TABLE [Operadores].[CheckpointRutas] CHECK CONSTRAINT [FK_CheckpointRutas_CheckPoint]
GO
ALTER TABLE [Operadores].[CheckpointRutas]  WITH CHECK ADD  CONSTRAINT [FK_CheckpointRutas_Rutas] FOREIGN KEY([RutaId])
REFERENCES [Operadores].[Rutas] ([Id])
GO
ALTER TABLE [Operadores].[CheckpointRutas] CHECK CONSTRAINT [FK_CheckpointRutas_Rutas]
GO
