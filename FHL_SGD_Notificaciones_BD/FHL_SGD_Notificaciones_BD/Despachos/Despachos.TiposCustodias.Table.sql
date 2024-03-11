USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[TiposCustodias]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[TiposCustodias](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_TipoCustodia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[TiposCustodias] ON 

INSERT [Despachos].[TiposCustodias] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Armada', N'usrPhoenixAdmin', 1, CAST(N'2023-08-07T00:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T18:58:15.1627186-06:00"}]')
INSERT [Despachos].[TiposCustodias] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'No armada', N'usrPhoenixAdmin', 1, CAST(N'2023-08-07T00:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T18:58:15.1627186-06:00"}]')
INSERT [Despachos].[TiposCustodias] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Hasta destino', N'usrPhoenixAdmin', 1, CAST(N'2023-08-07T00:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T18:58:15.1627186-06:00"}]')
INSERT [Despachos].[TiposCustodias] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Hasta caseta', N'usrPhoenixAdmin', 1, CAST(N'2023-08-07T00:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T18:58:15.1627186-06:00"}]')
INSERT [Despachos].[TiposCustodias] ([Id], [Nombre], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'ArmadaInsertar', N'usrPhoenixAdmin', 1, CAST(N'2024-01-04T16:55:29.967' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T18:58:15.1627186-06:00"}]')
SET IDENTITY_INSERT [Despachos].[TiposCustodias] OFF
GO
