USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[Custodias]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[Custodias](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[NombreCustodio] [varchar](300) NULL,
	[NumeroTelefono] [varchar](15) NULL,
	[PlacasVehiculo] [varchar](10) NULL,
	[Codigo] [varchar](50) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Custodias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[Custodias] ON 

INSERT [Despachos].[Custodias] ([Id], [DespachoId], [NombreCustodio], [NumeroTelefono], [PlacasVehiculo], [Codigo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (40060, 4, N'prueba1', N'7353586327', N'pl42d', NULL, N'usrphoenixadmin', 1, CAST(N'2024-02-07T16:20:40.200' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T16:20:16.3123958-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-07T16:23:30.0241687-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T17:21:19.5874165-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T17:26:46.7635614-06:00"}]')
INSERT [Despachos].[Custodias] ([Id], [DespachoId], [NombreCustodio], [NumeroTelefono], [PlacasVehiculo], [Codigo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (40061, 10215, N'test1', N'2222222222', N'ol44sas', NULL, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T16:25:00.800' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T16:24:48.5548325-06:00"}]')
INSERT [Despachos].[Custodias] ([Id], [DespachoId], [NombreCustodio], [NumeroTelefono], [PlacasVehiculo], [Codigo], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (40062, 2, N'prueba', N'6767676767', N'23', NULL, N'usr', 1, CAST(N'2024-03-03T15:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T16:20:16.3123958-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-07T16:23:30.0241687-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T17:21:19.5874165-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T17:26:46.7635614-06:00"}]')
SET IDENTITY_INSERT [Despachos].[Custodias] OFF
GO
