USE [SGD_V1]
GO
/****** Object:  Table [Remolques].[Remolques]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Remolques].[Remolques](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Placa] [varchar](50) NULL,
	[Economico] [varchar](50) NULL,
	[VIN] [varchar](50) NULL,
	[MarcaId] [bigint] NULL,
	[ModeloId] [bigint] NULL,
	[Anio] [int] NULL,
	[ColorId] [bigint] NULL,
	[ProveedorSeguro] [bigint] NULL,
	[TipoId] [bigint] NULL,
	[PolizaSeguro] [varchar](50) NULL,
	[Permiso] [varchar](50) NULL,
	[TipoPermiso] [varbinary](50) NULL,
	[Habilidades] [varchar](3000) NULL,
	[VolumenMaximo] [int] NULL,
	[VolumenUtil] [int] NULL,
	[UnidadVolumen] [int] NULL,
	[PesoMaximo] [int] NULL,
	[UnidadPeso] [int] NULL,
	[RangoOperacion] [varchar](3000) NULL,
	[UltimoOdometro] [numeric](18, 2) NULL,
	[Comentarios] [varchar](1000) NULL,
	[ConfiguracionId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Remolques] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Remolques].[Remolques] ON 

INSERT [Remolques].[Remolques] ([Id], [Placa], [Economico], [VIN], [MarcaId], [ModeloId], [Anio], [ColorId], [ProveedorSeguro], [TipoId], [PolizaSeguro], [Permiso], [TipoPermiso], [Habilidades], [VolumenMaximo], [VolumenUtil], [UnidadVolumen], [PesoMaximo], [UnidadPeso], [RangoOperacion], [UltimoOdometro], [Comentarios], [ConfiguracionId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'DFGH456', N'DF345', N'1FTEW1EG8KFA71608', 4, 11, 2004, 4, 1, 1, N'Poliza seguro', N'Prueba', NULL, NULL, 32, 23, 54, 234, 34, N'Prueba', CAST(23.20 AS Numeric(18, 2)), N'Si  comentarios', 1, N'usrPhoenixAdmin', 1, CAST(N'2023-08-30T00:00:00.000' AS DateTime), N'[{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Alta de registro","trail_timemark":"2023-07-19T14:44:20.7067429-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-04T16:11:30.8576179-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-04T16:12:30.3462882-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-04T16:18:08.3812282-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-04T16:20:54.7181417-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-04T16:21:17.5440006-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-08-07T14:34:56.0414226-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de registro","trail_timemark":"2023-08-14T12:50:31.950036-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-15T13:00:06.1487665-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-15T13:00:26.3209827-06:00"},{"trail_system_user":"angel","trail_workstation":"PHOENIX","trail_notes":"Actualización de registro","trail_timemark":"2023-08-15T17:45:44.381471-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-18T14:18:28.6200474-06:00"},{"trail_system_user":"pep.desarrollo","trail_workstation":"LAPTOP-KMD9MDO4","trail_notes":"Actualización de registro","trail_timemark":"2023-08-18T16:22:46.2543361-06:00"}]')
SET IDENTITY_INSERT [Remolques].[Remolques] OFF
GO
ALTER TABLE [Remolques].[Remolques]  WITH CHECK ADD  CONSTRAINT [FK_Remolques_Colores] FOREIGN KEY([ColorId])
REFERENCES [Vehiculos].[Colores] ([Id])
GO
ALTER TABLE [Remolques].[Remolques] CHECK CONSTRAINT [FK_Remolques_Colores]
GO
ALTER TABLE [Remolques].[Remolques]  WITH CHECK ADD  CONSTRAINT [FK_Remolques_Configuraciones] FOREIGN KEY([ConfiguracionId])
REFERENCES [Vehiculos].[Configuraciones] ([Id])
GO
ALTER TABLE [Remolques].[Remolques] CHECK CONSTRAINT [FK_Remolques_Configuraciones]
GO
ALTER TABLE [Remolques].[Remolques]  WITH CHECK ADD  CONSTRAINT [FK_Remolques_Marcas] FOREIGN KEY([MarcaId])
REFERENCES [Vehiculos].[Marcas] ([Id])
GO
ALTER TABLE [Remolques].[Remolques] CHECK CONSTRAINT [FK_Remolques_Marcas]
GO
ALTER TABLE [Remolques].[Remolques]  WITH CHECK ADD  CONSTRAINT [FK_Remolques_Tipos] FOREIGN KEY([TipoId])
REFERENCES [Vehiculos].[Tipos] ([Id])
GO
ALTER TABLE [Remolques].[Remolques] CHECK CONSTRAINT [FK_Remolques_Tipos]
GO
