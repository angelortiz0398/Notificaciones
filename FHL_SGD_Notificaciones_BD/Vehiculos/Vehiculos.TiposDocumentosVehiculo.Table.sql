USE [SGD_V1]
GO
/****** Object:  Table [Vehiculos].[TiposDocumentosVehiculo]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Vehiculos].[TiposDocumentosVehiculo](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](500) NULL,
	[Requerido] [bit] NULL,
	[Uso] [varchar](150) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_TiposDocumentos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Vehiculos].[TiposDocumentosVehiculo] ON 

INSERT [Vehiculos].[TiposDocumentosVehiculo] ([Id], [Nombre], [Requerido], [Uso], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Tipo 1', 1, N'Público', N'Desarrollo', 1, CAST(N'2023-06-01T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"},{"trail_system_user":"erickdominguez","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-07-13T14:38:28.312173-06:00"},{"trail_system_user":"erickdominguez","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-07-13T14:38:28.312173-06:00"},{"trail_system_user":"erickdominguez","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-07-13T14:38:28.312173-06:00"},{"trail_system_user":"erickdominguez","trail_workstation":null,"trail_notes":"Actualización de Registro","trail_timemark":"2023-07-14T10:59:40.300616-06:00"}]')
INSERT [Vehiculos].[TiposDocumentosVehiculo] ([Id], [Nombre], [Requerido], [Uso], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Tipo 2', 1, N'Público', N'usrPhoenixAdmin', 1, CAST(N'2023-07-13T00:00:00.000' AS DateTime), N'[{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Actualizacion de Registro","trail_timemark":"2023-04-21T17:18:01.3082684-06:00"},{"trail_system_user":"Phoenix","trail_workstation":"DESKTOP-T70QR7H","trail_notes":"Altade Registro","trail_timemark":"2023-04-24T13:59:21.5802981-06:00"}]')
INSERT [Vehiculos].[TiposDocumentosVehiculo] ([Id], [Nombre], [Requerido], [Uso], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Licencia C', 1, N'Privado', N'usrPhoenixAdmin', 1, CAST(N'2023-07-14T11:02:04.490' AS DateTime), N'[{"trail_system_user":"erickdominguez","trail_workstation":null,"trail_notes":"Alta de Registro","trail_timemark":"2023-07-14T10:59:40.300616-06:00"}]')
INSERT [Vehiculos].[TiposDocumentosVehiculo] ([Id], [Nombre], [Requerido], [Uso], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Licencia Tipo E', 1, N'Público', N'usrPhoenixAdmin', 1, CAST(N'2023-07-18T12:45:13.083' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-07-18T12:44:32.1412014-06:00"}]')
SET IDENTITY_INSERT [Vehiculos].[TiposDocumentosVehiculo] OFF
GO
