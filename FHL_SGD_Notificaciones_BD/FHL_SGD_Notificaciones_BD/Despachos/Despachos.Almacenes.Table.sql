USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[Almacenes]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[Almacenes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](300) NULL,
	[Referencia] [varchar](150) NULL,
	[ColaboradorId] [bigint] NULL,
	[CentroDistribucionId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Almacenes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[Almacenes] ON 

INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'almacén 1', N'123sd', 12, 1, N'usrphoenixadmin', 0, CAST(N'2023-10-25T11:45:40.303' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-25T11:45:08.4807304-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-25T11:48:03.5252187-06:00"},{"trail_system_user":null,"trail_workstation":null,"trail_notes":"Registro Eliminado","trail_timemark":"0001-01-01T00:00:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'almacén 1 ', N'23ersw|', 8, 2, N'usrphoenixadmin', 0, CAST(N'2023-10-25T11:46:01.020' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-25T11:45:43.527242-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-25T11:48:06.5042231-06:00"},{"trail_system_user":null,"trail_workstation":null,"trail_notes":"Registro Eliminado","trail_timemark":"0001-01-01T00:00:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'ALMACENd 11overa', N'ABCsfgover', 9, 2, N'usrphoenixadmin', 1, CAST(N'2023-10-25T14:59:57.323' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-25T14:59:44.9498391-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T14:50:54.420271-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T14:51:04.6930338-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T14:51:11.5328781-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T14:51:23.7830915-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T16:49:28.0432754-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T16:50:00.9489724-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T16:50:32.903562-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:17:41.9850847-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:17:41.9850847-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:19:04.0333505-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:29:09.663091-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:29:29.7925627-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:29:37.8852774-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T17:29:45.5162287-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-29T10:38:55.9472394-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-01T11:49:09.1717278-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-01T12:43:43.4805884-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T13:55:55.0149042-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T13:56:12.8100686-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T13:56:12.8100686-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T14:02:04.7188785-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:33:22.4899257-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:38:32.86272-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:38:36.955322-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:42:43.2283293-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:43:32.2972817-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:45:25.8780897-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'almacen 1', N'wsd2', 7, 1, N'usrPhoenixAdmin', 1, CAST(N'2023-10-25T16:42:42.983' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-25T16:42:27.1173235-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-29T10:39:07.5060832-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'almacen act ', N'sd3', 8, 1, N'usrphoenixadmin', 0, CAST(N'2023-10-25T16:44:50.237' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-10-25T16:44:05.8453147-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, N'almacen', N't1', 7, 2, N'usrPhoenixAdmin', 0, CAST(N'2023-11-03T12:28:24.890' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-03T12:27:06.1882927-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, N'Almacen 3', N'sin referencia1e', 13, 2, N'usrphoenixadmin', 1, CAST(N'2023-11-03T12:31:54.003' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-03T12:31:06.8422827-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T12:35:54.6345331-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T12:52:18.6182898-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T12:53:39.1371085-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T12:53:57.5641667-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-03T12:54:04.8442137-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-06T13:24:01.423015-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-06T13:33:16.9254826-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T14:02:30.8334731-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, N'8', N'ref', 20, 1, N'usrphoenixadmin', 0, CAST(N'2023-11-06T13:55:35.103' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-06T13:55:14.2986764-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-12-20T09:59:12.4525358-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-12-20T09:59:20.9106842-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (9, N'8', N'ref', 20, 1, N'usrPhoenixAdmin', 0, CAST(N'2023-11-06T13:55:35.457' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-06T13:55:14.2986764-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-06T13:55:14.2986764-06:00"},{"trail_system_user":null,"trail_workstation":null,"trail_notes":"Registro Eliminado","trail_timemark":"0001-01-01T00:00:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10008, N'almacen', N't1fg', 7, 2, N'usrphoenixadmin', 1, CAST(N'2024-01-04T12:18:23.120' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-03T12:27:06.1882927-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T14:02:17.2655669-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10013, N'almacenover', N't1over', 7, 1, N'usrphoenixadmin', 1, CAST(N'2024-01-30T13:45:57.940' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T14:02:09.5087897-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T14:02:12.1667467-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:38:55.9385171-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:39:24.8383101-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:39:44.4842247-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-08T16:40:11.2482256-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10014, N'Pruebasp', N'dsf', 22, 2, N'usrphoenixadmin', 1, CAST(N'2024-01-30T14:33:09.457' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-30T14:32:45.3212021-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10015, N'pruebasp', N'sdf', 17, 1, N'usrphoenixadmin', 1, CAST(N'2024-01-30T14:34:01.137' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-30T14:33:44.4022462-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10016, N'Almacen P1', N'ref12', 9, 2, N'usrPhoenixAdmin', 1, CAST(N'2024-02-01T12:03:01.693' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-01T11:56:03.6126279-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10017, N'Almacen 4', N'A4', 20, 1, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T14:21:26.403' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:20:33.875964-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10018, N'Almacen 5', N'A4', 20, 1, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T14:22:35.013' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:21:54.7227503-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10019, N'Almacen 5', N'A4', 20, 2, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T14:25:58.167' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T14:25:19.5533388-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10020, N'almacen', N'q123', 23, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T16:44:11.957' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:43:59.9857206-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10021, N'repetido bitacora', N'qwe', 21, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T16:47:21.297' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:46:50.6972878-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10022, N'almacens', N'sd3', 17, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T16:59:09.513' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:58:34.3636746-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T16:58:34.3636746-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10023, N'almacén', N'dsss', 23, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T17:02:14.570' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T17:01:40.6988501-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10024, N'Almacénss', N'sfd', 21, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T17:16:20.560' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T17:15:38.2678196-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10025, N'almacenzzzz', N'asd', 20, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-08T17:30:29.757' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-08T17:29:15.4723084-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10026, N'almacendfg', N'sfd', 22, 1, N'usrphoenixadmin', 1, CAST(N'2024-02-09T14:13:58.267' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-02-09T14:13:04.5914139-06:00"}]')
INSERT [Despachos].[Almacenes] ([Id], [Nombre], [Referencia], [ColaboradorId], [CentroDistribucionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (20020, N'almacen4', N'77', 17, 1, N'usrPhoenixAdmin', 1, CAST(N'2024-02-09T18:38:58.977' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-09T18:38:33.4558698-06:00"}]')
SET IDENTITY_INSERT [Despachos].[Almacenes] OFF
GO
ALTER TABLE [Despachos].[Almacenes]  WITH CHECK ADD  CONSTRAINT [FK_Almacenes_CentrosDistribuciones] FOREIGN KEY([CentroDistribucionId])
REFERENCES [Operadores].[CentrosDistribuciones] ([Id])
GO
ALTER TABLE [Despachos].[Almacenes] CHECK CONSTRAINT [FK_Almacenes_CentrosDistribuciones]
GO
