USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[RegistrosLiquidaciones]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[RegistrosLiquidaciones](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[ColaboradorId] [bigint] NOT NULL,
	[TipoGastoId] [bigint] NOT NULL,
	[Deducible] [bit] NULL,
	[MonedaIdMonto] [int] NOT NULL,
	[Monto] [numeric](18, 2) NULL,
	[Impuesto] [int] NULL,
	[Adjunto] [varchar](500) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_RegistrosLiquidaciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[DespachoId] ASC,
	[ColaboradorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[RegistrosLiquidaciones] ON 

INSERT [Despachos].[RegistrosLiquidaciones] ([Id], [DespachoId], [ColaboradorId], [TipoGastoId], [Deducible], [MonedaIdMonto], [Monto], [Impuesto], [Adjunto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (7, 30077, 1727, 10002, 0, 1, CAST(500.00 AS Numeric(18, 2)), 10, NULL, N'usrPhoenixAdmin', 0, CAST(N'2024-03-07T17:48:52.250' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-03-07T17:48:40.4684978-06:00"}]')
INSERT [Despachos].[RegistrosLiquidaciones] ([Id], [DespachoId], [ColaboradorId], [TipoGastoId], [Deducible], [MonedaIdMonto], [Monto], [Impuesto], [Adjunto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, 30067, 1727, 10002, 0, 1, CAST(1500.00 AS Numeric(18, 2)), 100, NULL, N'usrPhoenixAdmin', 1, CAST(N'2024-03-07T17:49:30.673' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-03-07T17:49:14.6858642-06:00"}]')
SET IDENTITY_INSERT [Despachos].[RegistrosLiquidaciones] OFF
GO
ALTER TABLE [Despachos].[RegistrosLiquidaciones]  WITH CHECK ADD  CONSTRAINT [FK_RegistrosLiquidaciones_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[RegistrosLiquidaciones] CHECK CONSTRAINT [FK_RegistrosLiquidaciones_Despachos]
GO
