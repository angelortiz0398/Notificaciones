USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Custodias]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Custodias](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](200) NOT NULL,
	[TipoTarifa] [int] NOT NULL,
	[MonedaIdCosto] [int] NULL,
	[Costo] [numeric](18, 2) NULL,
	[MonedaIdCostoArmada] [int] NULL,
	[CostoArmada] [numeric](18, 2) NULL,
	[MonedaIdCostoNoArmada] [int] NULL,
	[CostoNoArmada] [numeric](18, 2) NULL,
	[MonedaIdValorMinimo] [int] NULL,
	[ValorMinimoArmada] [numeric](18, 2) NULL,
	[Origen] [varchar](5000) NULL,
	[Destino] [varchar](5000) NULL,
	[TipoCustodia] [varchar](500) NOT NULL,
	[Utilidad] [int] NOT NULL,
	[ProveedorId] [bigint] NOT NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Custodias_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Clientes].[Custodias] ON 

INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'Custodia Vallarta', 1, NULL, NULL, 1, CAST(5000.00 AS Numeric(18, 2)), 1, CAST(2500.00 AS Numeric(18, 2)), 1, CAST(3500.00 AS Numeric(18, 2)), N'[1]', N'[3]', N'1', 90, 2, N'usrPhoenixAdmin', 1, CAST(N'2023-09-29T11:21:33.337' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-09-29T11:20:24.9407663-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2023-10-25T11:49:30.2847445-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-21T17:22:22.3475641-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-17T16:36:55.9489004-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Custodia CDMX', 1, NULL, NULL, 1, CAST(2500.00 AS Numeric(18, 2)), 1, CAST(2000.00 AS Numeric(18, 2)), 1, CAST(5000.00 AS Numeric(18, 2)), N'[5]', N'[3, 6]', N'3', 90, 1, N'usrPhoenixAdmin', 1, CAST(N'2023-09-29T11:23:43.503' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-09-29T11:22:44.6833671-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, N'pruebacustodia', 1, NULL, NULL, 1, CAST(1345.00 AS Numeric(18, 2)), 1, CAST(1234.00 AS Numeric(18, 2)), 1, CAST(2000.00 AS Numeric(18, 2)), N'[3, 1]', N'[2, 4]', N'1', 50, 3, N'usrPhoenixAdmin', 1, CAST(N'2023-10-18T19:06:55.537' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-10-18T19:05:18.8029171-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, N'1', 2, 1, CAST(1.00 AS Numeric(18, 2)), 1, NULL, 1, NULL, 1, NULL, N'[3]', N'[4]', N'2', 2, 2, N'usrPhoenixAdmin', 1, CAST(N'2023-11-22T11:45:35.477' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-22T11:44:30.7704123-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10004, N'Prueba', 1, NULL, NULL, 1, CAST(15230.00 AS Numeric(18, 2)), 1, CAST(1550.00 AS Numeric(18, 2)), 1, CAST(15015.00 AS Numeric(18, 2)), N'[5, 2, 20030]', N'[20031, 2, 1]', N'3', 20, 3, N'usrPhoenixAdmin', 1, CAST(N'2023-11-28T12:16:56.997' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-11-28T12:16:25.1483756-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10005, N'Prueba 2', 1, NULL, NULL, 1, CAST(165412.00 AS Numeric(18, 2)), 1, CAST(54210.00 AS Numeric(18, 2)), 1, CAST(1221.00 AS Numeric(18, 2)), N'[14, 3, 1]', N'[3, 1]', N'4', 50, 3, N'usrPhoenixAdmin', 1, CAST(N'2023-11-28T12:17:23.267' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2023-11-28T12:17:03.4537854-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-12T11:41:00.8761502-06:00"},{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-12T11:43:12.542339-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10006, N'1', 2, 1, CAST(1.00 AS Numeric(18, 2)), 1, NULL, NULL, NULL, 1, NULL, N'[3]', N'[4]', N'2', 2, 2, N'usrPhoenixAdmin', 1, CAST(N'2023-12-28T17:33:20.787' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2023-11-22T11:44:30.7704123-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (20015, N'custodia n1', 1, NULL, NULL, 1, CAST(200.00 AS Numeric(18, 2)), 1, CAST(100.00 AS Numeric(18, 2)), 1, CAST(300.00 AS Numeric(18, 2)), N'[8, 20030]', N'[5]', N'1', 5, 3, N'usrPhoenixAdmin', 1, CAST(N'2024-01-16T13:58:44.017' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-01-16T13:55:01.5210854-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-01-16T13:59:19.7666985-06:00"}]')
INSERT [Clientes].[Custodias] ([Id], [Nombre], [TipoTarifa], [MonedaIdCosto], [Costo], [MonedaIdCostoArmada], [CostoArmada], [MonedaIdCostoNoArmada], [CostoNoArmada], [MonedaIdValorMinimo], [ValorMinimoArmada], [Origen], [Destino], [TipoCustodia], [Utilidad], [ProveedorId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (20016, N'c3', 2, 1, CAST(600.00 AS Numeric(18, 2)), 1, NULL, 1, NULL, 1, NULL, N'[30034]', N'[30037]', N'tp01', 20, 3, N'usrPhoenixAdmin', 1, CAST(N'2024-01-22T17:08:37.130' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de Registro","trail_timemark":"2024-01-22T16:52:02.9286568-06:00"}]')
SET IDENTITY_INSERT [Clientes].[Custodias] OFF
GO
