USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[RegistrosDispersiones]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[RegistrosDispersiones](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[ColaboradorId] [bigint] NOT NULL,
	[MonedaIdMonto] [int] NOT NULL,
	[Monto] [numeric](18, 2) NULL,
	[TipoGastoId] [bigint] NULL,
	[MetodoId] [int] NULL,
	[GastoOperativoId] [int] NULL,
	[ColaboradorAutorizadoId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_RegistrosDispersiones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC,
	[ColaboradorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[RegistrosDispersiones] ON 

INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 6, 7, 1, CAST(300.00 AS Numeric(18, 2)), 10003, 1, 1, 7, N'usrPhoenixAdmin', 0, CAST(N'2024-02-07T18:45:22.327' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-07T18:44:55.0711103-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-07T18:45:25.3307533-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, 6, 20, 1, CAST(20.00 AS Numeric(18, 2)), 4, 1, 1, 9, N'usrPhoenixAdmin', 0, CAST(N'2024-02-07T19:19:36.947' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2024-02-07T19:19:30.5124404-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, 1, 6, 1, CAST(20.00 AS Numeric(18, 2)), 4, 1, 1, 9, N'usrPhoenixAdmin', 1, CAST(N'2024-02-07T19:20:13.457' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2024-02-07T19:19:30.5124404-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, 4, 23, 1, CAST(560.00 AS Numeric(18, 2)), 10005, 2, 1, 19, N'usrPhoenixAdmin', 0, CAST(N'2024-02-13T18:33:58.813' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-02-13T18:33:48.0821788-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, 20068, 17, 1, CAST(800.00 AS Numeric(18, 2)), 10006, 1, 1, 20, N'usrPhoenixAdmin', 1, CAST(N'2024-02-13T18:36:40.080' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-02-13T18:35:58.7084713-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T09:45:59.7240807-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-14T09:59:51.5019753-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-07T12:26:54.7582259-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, 1, 6, 1, CAST(100.00 AS Numeric(18, 2)), 5, 1, 1, 1723, N'usrPhoenixAdmin', 1, CAST(N'2024-03-01T10:58:35.487' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-03-01T10:58:14.8769737-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-07T17:46:37.2294353-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, 20069, 1727, 1, CAST(200.00 AS Numeric(18, 2)), 10005, 2, 2, 1726, N'usrPhoenixAdmin', 1, CAST(N'2024-03-01T10:59:13.727' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-03-01T10:58:57.7141403-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-07T17:43:36.5633309-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-03-07T17:43:52.4919909-06:00"}]')
INSERT [Despachos].[RegistrosDispersiones] ([Id], [DespachoId], [ColaboradorId], [MonedaIdMonto], [Monto], [TipoGastoId], [MetodoId], [GastoOperativoId], [ColaboradorAutorizadoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (9, 30067, 1727, 1, CAST(500.00 AS Numeric(18, 2)), 10003, 2, 1, 1723, N'usrPhoenixAdmin', 1, CAST(N'2024-03-07T12:43:41.613' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-03-07T12:43:24.0035837-06:00"}]')
SET IDENTITY_INSERT [Despachos].[RegistrosDispersiones] OFF
GO
ALTER TABLE [Despachos].[RegistrosDispersiones]  WITH CHECK ADD  CONSTRAINT [FK_RegistrosDispersiones_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[RegistrosDispersiones] CHECK CONSTRAINT [FK_RegistrosDispersiones_Despachos]
GO
ALTER TABLE [Despachos].[RegistrosDispersiones]  WITH CHECK ADD  CONSTRAINT [FK_RegistrosDispersiones_TipoGastos] FOREIGN KEY([TipoGastoId])
REFERENCES [Despachos].[TipoGastos] ([Id])
GO
ALTER TABLE [Despachos].[RegistrosDispersiones] CHECK CONSTRAINT [FK_RegistrosDispersiones_TipoGastos]
GO
