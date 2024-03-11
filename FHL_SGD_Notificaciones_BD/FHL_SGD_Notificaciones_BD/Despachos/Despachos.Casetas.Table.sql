USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[Casetas]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[Casetas](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FechaHora] [datetime] NOT NULL,
	[VehiculoId] [bigint] NOT NULL,
	[DespachoId] [bigint] NULL,
	[Estacion] [varchar](500) NULL,
	[Referencia] [varchar](500) NULL,
	[MonedaIdMonto] [int] NOT NULL,
	[Monto] [numeric](18, 2) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Casetas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[FechaHora] ASC,
	[VehiculoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[Casetas] ON 

INSERT [Despachos].[Casetas] ([Id], [FechaHora], [VehiculoId], [DespachoId], [Estacion], [Referencia], [MonedaIdMonto], [Monto], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (24, CAST(N'2024-02-23T17:51:27.000' AS DateTime), 20040, 20068, N'Mérida', N'1234584', 1, CAST(1200.00 AS Numeric(18, 2)), N'usrPhoenixAdmin', 1, CAST(N'2024-02-23T17:51:42.900' AS DateTime), N'[{"trail_system_user":"erick","trail_workstation":"NEWLAND-ERICK","trail_notes":"Alta de Registro","trail_timemark":"2024-02-23T17:51:27.960759-06:00"}]')
SET IDENTITY_INSERT [Despachos].[Casetas] OFF
GO
