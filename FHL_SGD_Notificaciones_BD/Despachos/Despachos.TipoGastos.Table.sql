USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[TipoGastos]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[TipoGastos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](150) NULL,
	[SATID] [int] NULL,
	[Axapta] [int] NULL,
	[CuentaContable] [varchar](150) NULL,
	[MonedaIdMontoMaximo] [int] NOT NULL,
	[MontoMaximo] [numeric](18, 2) NULL,
	[ColaboradorAutorizadoId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_TipoGastos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[TipoGastos] ON 

INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Alimentos', 1245, 1245, N'BBVA', 2, CAST(2500.00 AS Numeric(18, 2)), 6, N'usrPhoenixAdmin', 0, CAST(N'2023-09-25T14:31:42.763' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-09-25T14:31:08.3460027-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-26T11:32:59.8966011-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-26T11:35:17.1461387-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-09-26T11:35:19.9370751-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'Casetas en efectivo', 54321, 54321, N'NU', 1, CAST(1500.00 AS Numeric(18, 2)), 7, N'usrPhoenixAdmin', 1, CAST(N'2023-09-26T11:37:50.677' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-09-26T11:35:56.4735925-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'Maniobras', 123456, 111111, N'HSBC', 1, CAST(10000.00 AS Numeric(18, 2)), 7, N'usrPhoenixAdmin', 1, CAST(N'2023-09-27T13:32:26.787' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-09-27T13:31:39.074661-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, N'Hoteles', 123, 123547, N'Citi', 1, CAST(1000.00 AS Numeric(18, 2)), 6, N'usrPhoenixAdmin', 1, CAST(N'2023-09-28T10:50:44.913' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-09-28T10:50:03.3565382-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10002, N'Otros', 123456, 123456, N'Inbursa', 1, CAST(50000.00 AS Numeric(18, 2)), 7, N'usrPhoenixAdmin', 1, CAST(N'2023-10-23T13:56:00.787' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-10-23T13:55:28.194049-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-12-06T17:19:59.2394622-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10003, N'Fletes', 1234567, 1234567, N'Plata', 1, CAST(6000.00 AS Numeric(18, 2)), 9, N'usrPhoenixAdmin', 1, CAST(N'2024-01-31T14:07:03.830' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-01-31T14:05:48.5599404-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-31T14:16:36.2648029-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:51.6086829-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:51.6086829-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:51.6086829-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:51.6086829-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:51.6086829-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10004, N'Alimentos', 111, 111, N'20', 1, CAST(30.00 AS Numeric(18, 2)), 19, N'usrPhoenixAdmin', 0, CAST(N'2024-02-07T19:23:07.593' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T19:22:50.0356112-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10005, N'Alimentos', 111, 111, N'111', 1, CAST(30.00 AS Numeric(18, 2)), 20, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T19:24:14.507' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T19:23:48.3987802-06:00"}]')
INSERT [Despachos].[TipoGastos] ([Id], [Nombre], [SATID], [Axapta], [CuentaContable], [MonedaIdMontoMaximo], [MontoMaximo], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10006, N'Comisiones bancarias', 88888888, 111, N'BA', 1, CAST(2000.00 AS Numeric(18, 2)), 23, N'usrPhoenixAdmin', 1, CAST(N'2024-02-09T13:28:06.770' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-09T13:27:10.2185779-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T13:40:46.5139997-06:00"}]')
SET IDENTITY_INSERT [Despachos].[TipoGastos] OFF
GO
