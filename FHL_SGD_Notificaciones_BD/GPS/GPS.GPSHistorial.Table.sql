USE [SGD_V1]
GO
/****** Object:  Table [GPS].[GPSHistorial]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GPS].[GPSHistorial](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[VehiculoId] [bigint] NOT NULL,
	[Imei] [bigint] NULL,
	[Nombre] [varchar](50) NULL,
	[Licencia] [varchar](50) NULL,
	[Latitud] [numeric](18, 6) NULL,
	[Longitud] [numeric](18, 6) NULL,
	[Curso] [int] NULL,
	[Velocidad] [numeric](18, 2) NULL,
	[Odometro] [numeric](18, 2) NULL,
	[PuertaCabina] [varchar](50) NULL,
	[PuertaCarga] [varchar](50) NULL,
	[Bateria] [numeric](18, 2) NULL,
	[UltimaPosicion] [datetime] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_GPSHistorial] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [GPS].[GPSHistorial] ON 

INSERT [GPS].[GPSHistorial] ([Id], [VehiculoId], [Imei], [Nombre], [Licencia], [Latitud], [Longitud], [Curso], [Velocidad], [Odometro], [PuertaCabina], [PuertaCarga], [Bateria], [UltimaPosicion], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (10, 2, 1201215414512, N'PRUEBA ACTUALIZAR DESDE HISTORIAL', N'Tipo A', CAST(185.340000 AS Numeric(18, 6)), CAST(128.430000 AS Numeric(18, 6)), 5, CAST(60.00 AS Numeric(18, 2)), CAST(800.00 AS Numeric(18, 2)), N'Vacia', N'Funcional', CAST(80.00 AS Numeric(18, 2)), CAST(N'2024-01-25T00:00:00.000' AS DateTime), N'usrPhoenixAdmin', 1, CAST(N'2024-02-29T12:02:56.193' AS DateTime), N'[{"trail_system_user":"Valen","trail_workstation":"VALENTIN","trail_notes":"Alta de registro","trail_timemark":"2023-10-27T12:54:00.2596292-06:00"}]')
SET IDENTITY_INSERT [GPS].[GPSHistorial] OFF
GO
