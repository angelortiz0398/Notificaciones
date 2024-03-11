USE [SGD_V1]
GO
/****** Object:  Table [Operadores].[CentrosDistribuciones]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Operadores].[CentrosDistribuciones](
	[Id] [bigint] NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Descripcion] [varchar](500) NULL,
	[Geolocalizacion] [varchar](100) NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_CentrosDistribuciones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [Operadores].[CentrosDistribuciones] ([Id], [Nombre], [Descripcion], [Geolocalizacion], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, N'CEDIS San Martin Obispo', N'CEDIS San Martin Obispo', N'123.123456,123.123456', N'usrPhoenixAdmin', 1, CAST(N'2023-07-21T09:50:55.270' AS DateTime), N'[{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-10T14:48:04.9288651-06:00"},{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-10T15:43:51.7590729-06:00"}]')
INSERT [Operadores].[CentrosDistribuciones] ([Id], [Nombre], [Descripcion], [Geolocalizacion], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, N'Ejemplo', N'Cedis de Ejemplo', N'123.123456,123.123456', N'usrPhoenixAdmin', 1, CAST(N'2023-07-21T09:50:55.197' AS DateTime), N'[{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Alta de Registro","trail_timemark":"2023-04-10T12:48:04.7905308-06:00"},{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-10T15:42:34.3431252-06:00"}]')
GO
