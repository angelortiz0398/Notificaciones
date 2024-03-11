USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[SiniestrosColaboradores]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[SiniestrosColaboradores](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ColaboradoresId] [bigint] NOT NULL,
	[FechaEvento] [datetime] NULL,
	[Geolocalizacion] [varchar](100) NULL,
	[ConResponsabilidad] [bit] NULL,
	[MonedaMontoCubrir] [int] NULL,
	[MontoCubrir] [numeric](18, 2) NULL,
	[PorcentajeDescuento] [int] NULL,
	[PierdeBono] [bit] NULL,
	[VehiculosId] [bigint] NULL,
	[CategoriaSiniestrosId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_SiniestrosColaboradores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[ColaboradoresId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Operadores].[SiniestrosColaboradores] ON 

INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 6, CAST(N'2023-09-25T00:00:00.000' AS DateTime), N'12345, -12345', 0, NULL, CAST(0.00 AS Numeric(18, 2)), 100, 0, 20103, 1, N'usrPhoenixAdmin', 1, CAST(N'2023-09-25T17:25:53.800' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-09-25T17:25:22.0175233-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, 21, CAST(N'2023-11-22T00:00:00.000' AS DateTime), N'20, -100', 0, NULL, CAST(10000.00 AS Numeric(18, 2)), 1, 1, 11, 1, N'usrPhoenixAdmin', 1, CAST(N'2023-11-22T12:07:06.957' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-22T12:06:20.38401-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10002, 21, CAST(N'2023-11-22T00:00:00.000' AS DateTime), N'21, -101', 0, NULL, CAST(10000.00 AS Numeric(18, 2)), 1, 1, 11, 1, N'usrPhoenixAdmin', 1, CAST(N'2024-01-08T14:25:03.103' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-22T12:06:20.38401-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10003, 23, CAST(N'2024-01-12T00:05:00.000' AS DateTime), N'20,100', 0, NULL, CAST(1500.00 AS Numeric(18, 2)), 15, 1, 20040, 3, N'usrPhoenixAdmin', 0, CAST(N'2024-01-12T12:25:29.120' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T12:24:34.3919134-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10004, 23, CAST(N'2024-01-12T00:15:00.000' AS DateTime), N'20,-115', 0, NULL, CAST(0.00 AS Numeric(18, 2)), 100, 0, 20038, 1, N'usrPhoenixAdmin', 1, CAST(N'2024-01-12T13:19:56.000' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:19:19.263942-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-12T13:19:56.8675182-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10005, 23, CAST(N'2024-01-12T00:16:00.000' AS DateTime), N'20,-110', 0, NULL, CAST(0.00 AS Numeric(18, 2)), 100, 0, 20039, 2, N'usrPhoenixAdmin', 1, CAST(N'2024-01-12T13:41:36.380' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T13:32:17.4429131-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10006, 23, CAST(N'2024-01-12T00:00:00.000' AS DateTime), N'20,-105', 0, NULL, CAST(2000.00 AS Numeric(18, 2)), 20, 0, 20040, 3, N'usrPhoenixAdmin', 1, CAST(N'2024-01-12T14:05:36.750' AS DateTime), N'[{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2024-01-12T14:05:08.6896289-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10007, 23, CAST(N'2024-01-16T00:00:00.000' AS DateTime), N'44.444,-22.200', 1, NULL, CAST(20006.00 AS Numeric(18, 2)), 13, 0, 20183, 3, N'usrPhoenixAdmin', 1, CAST(N'2024-01-16T17:17:39.410' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-01-16T16:59:47.5719857-06:00"}]')
INSERT [Operadores].[SiniestrosColaboradores] ([Id], [ColaboradoresId], [FechaEvento], [Geolocalizacion], [ConResponsabilidad], [MonedaMontoCubrir], [MontoCubrir], [PorcentajeDescuento], [PierdeBono], [VehiculosId], [CategoriaSiniestrosId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10008, 2, CAST(N'2024-02-19T13:01:00.000' AS DateTime), N'132, -123', 0, NULL, CAST(1.00 AS Numeric(18, 2)), 0, 0, 40195, 3, N'usrPhoenixAdmin', 1, CAST(N'2024-02-19T14:32:27.150' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-02-19T14:31:38.2299098-06:00"}]')
SET IDENTITY_INSERT [Operadores].[SiniestrosColaboradores] OFF
GO
ALTER TABLE [Operadores].[SiniestrosColaboradores]  WITH CHECK ADD  CONSTRAINT [FK_SiniestrosColaboradores_CategoriasSiniestros] FOREIGN KEY([CategoriaSiniestrosId])
REFERENCES [Operadores].[CategoriasSiniestros] ([Id])
GO
ALTER TABLE [Operadores].[SiniestrosColaboradores] CHECK CONSTRAINT [FK_SiniestrosColaboradores_CategoriasSiniestros]
GO
ALTER TABLE [Operadores].[SiniestrosColaboradores]  WITH NOCHECK ADD  CONSTRAINT [FK_SiniestrosColaboradores_Colaboradores] FOREIGN KEY([ColaboradoresId])
REFERENCES [Operadores].[Colaboradores] ([Id])
GO
ALTER TABLE [Operadores].[SiniestrosColaboradores] NOCHECK CONSTRAINT [FK_SiniestrosColaboradores_Colaboradores]
GO
