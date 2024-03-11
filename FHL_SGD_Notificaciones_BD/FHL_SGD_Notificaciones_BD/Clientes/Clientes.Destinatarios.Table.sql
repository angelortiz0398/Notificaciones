USE [SGD_V1]
GO
/****** Object:  Table [Clientes].[Destinatarios]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Clientes].[Destinatarios](
	[Id] [bigint] NOT NULL,
	[ClienteId] [bigint] NOT NULL,
	[RazonSocial] [varchar](500) NULL,
	[RFC] [varchar](14) NULL,
	[AxaptaId] [varchar](50) NULL,
	[Referencia] [varchar](500) NULL,
	[Calle] [varchar](500) NULL,
	[NumeroExterior] [varchar](20) NULL,
	[NumeroInterior] [varchar](20) NULL,
	[Colonia] [varchar](500) NULL,
	[Localidad] [varchar](500) NULL,
	[Municipio] [varchar](500) NULL,
	[Estado] [varchar](500) NULL,
	[Pais] [varchar](150) NULL,
	[CodigoPostal] [int] NULL,
	[Coordenadas] [varchar](300) NULL,
	[RecepcionCita] [bit] NULL,
	[VentanaAtencion] [varchar](1500) NULL,
	[RestriccionCirculacion] [varchar](500) NULL,
	[HabilidadVehiculo] [varchar](2000) NULL,
	[DocumentoVehiculo] [varchar](2000) NULL,
	[HabilidadOperador] [varchar](2000) NULL,
	[DocumentoOperador] [varchar](2000) NULL,
	[HabilidadAuxiliar] [varchar](2000) NULL,
	[DocumentoAuxiliar] [varchar](2000) NULL,
	[EvidenciaSalida] [varchar](2000) NULL,
	[EvidenciaLlegada] [varchar](2000) NULL,
	[Sellos] [bit] NULL,
	[Checklist] [varchar](2000) NULL,
	[Contacto] [varchar](2000) NULL,
	[Geolocalizacion] [varchar](2000) NULL,
	[TiempoParado] [int] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_Destinatarios] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[ClienteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 1, N'Razón Social Prueba S.A. de C.V.', N'XAXX010101000', NULL, N'H', N'Prueba 1', N'151', N'1516', N'Colonia', NULL, NULL, NULL, NULL, 54090, NULL, 1, N'{"HorarioDesde":"11:05:00","HorarioHata":"20:57:00"}', N'{"CirculacionDesde":"11:26:00","CirculacionHasta":"00:00:00"}', N'[{"Llave":2,"Valor":"Rampa Hidraulica"},{"Llave":5,"Valor":"Habilidad 3"}]', N'[{"Llave":1,"Valor":"Tipo 1"}]', N'[{"Llave":1,"Valor":"Habilidad 1"}]', N'[{"Llave":34,"Valor":"Acta"},{"Llave":30062,"Valor":"DocumentPerfilVelocidad- RE5028 (9)"}]', N'[{"Llave":3,"Valor":"Habilidad 3"}]', N'[{"Llave":33,"Valor":"Permiso"}]', N'[{"Llave":2,"Valor":"Fotografia de Carga"},{"Llave":8,"Valor":"Fotografia Guia de embarque"}]', N'[{"Llave":5,"Valor":"Fotografia de talon de embarque"}]', 1, N'[{"Checklist":2,"inicio":"2023-08-15T00:00:00","fin":"2023-08-16T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false},{"Checklist":4,"inicio":"2023-08-17T00:00:00","fin":"2023-08-20T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false}]', N'{"Id":5,"Nombre":"Esteban","Email":"esteban@gmail.com","Telefono":"5555555555","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":"Salidas","Cada":0}', 10, N'usrPhoenixAdmin', 1, CAST(N'2024-03-07T12:21:56.393' AS DateTime), N'[{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Alta de Registro","trail_timemark":"2023-04-21T23:26:53.0997007+00:00"},{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-21T23:31:39.4250146+00:00"},{"trail_system_user":"Oscar","trail_workstation":"FHLLAP440","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-21T23:52:18.1812784+00:00"},{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK00004V","trail_notes":"Actualización de Registro","trail_timemark":"2023-04-24T18:53:10.5225635+00:00"}]')
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (2, 2, N'Liverpool Sa de CV', N'XAXX010101000', NULL, N'Liv01', N'Calle', N'1', N'1', NULL, NULL, NULL, NULL, NULL, 2120, N'19.457183, -99.095283

', 0, N'{"HorarioDesde":"13:00:00","HorarioHata":"16:10:00"}', N'{"CirculacionDesde":"13:20:00","CirculacionHasta":"13:25:00"}', N'[{"Llave":1,"Valor":"Matachispas"}]', N'[{"Llave":2,"Valor":"Pedimento"}]', N'[{"Llave":2,"Valor":"Habilidad 2"}]', N'[{"Llave":34,"Valor":"Acta"}]', N'[{"Llave":2,"Valor":"Habilidad 2"}]', N'[{"Llave":35,"Valor":"Certificado"}]', N'[{"Llave":1,"Valor":"Firma de quien entrega"}]', N'[{"Llave":2,"Valor":"Fotografia de Carga"}]', 0, N'[{"Checklist":0,"inicio":"2023-11-22T00:00:00-06:00","fin":"2023-11-23T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false}]', N'{"Id":1,"Nombre":"Valaentin","Email":"valentin@gmail.com","Telefono":"1111111111","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":null,"Cada":null}', 2, N'usrPhoenixAdmin', 1, CAST(N'2024-03-07T12:21:56.423' AS DateTime), N'[{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK0000HK","trail_notes":"Alta de Registro","trail_timemark":"2023-06-16T17:17:46.8771057+00:00"}]')
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (3, 1, N'Giorgio Armani Sa de CV', N'XAXX010101000', NULL, N'Gio01', N'Calle', N'2', N'1', NULL, NULL, NULL, NULL, NULL, 54090, N'19.465621, -99.13225
', NULL, N'{"HorarioDesde":"13:00:00","HorarioHata":"16:10:00"}', N'{"CirculacionDesde":"13:20:00","CirculacionHasta":"13:25:00"}', N'[{"Llave":3,"Valor":"Habilidad 1"},{"Llave":10,"Valor":"Habilidad 8 "},{"Llave":9,"Valor":"Habilidad 7"}]', N'[{"Llave":1,"Valor":"Tipo 1"},{"Llave":3,"Valor":"Licencia C"}]', NULL, N'[{"Llave":34,"Valor":"Acta"},{"Llave":33,"Valor":"Permiso"}]', N'[{"Llave":5,"Valor":"Habilidad 5"},{"Llave":3,"Valor":"Habilidad 3"}]', N'[{"Llave":45,"Valor":"Licencia Tipo A"},{"Llave":35,"Valor":"Certificado"}]', NULL, NULL, NULL, N'[{"Checklist":6,"inicio":"2023-08-15T00:00:00","fin":"2023-08-16T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false},{"Checklist":16,"inicio":"2023-09-26T00:00:00-06:00","fin":"2023-09-30T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false}]', N'{"Id":1,"Nombre":"Valaentin","Email":"valentin@gmail.com","Telefono":"1111111111","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":null,"Cada":null}', NULL, NULL, 1, CAST(N'2024-03-07T12:21:56.410' AS DateTime), N'[{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK0000HK","trail_notes":"Alta de Registro","trail_timemark":"2023-06-16T17:19:59.8967101+00:00"}]')
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (4, 4, N'Yves Sa de Cv', N'XAXX010101000', NULL, N'Yves01', N'calle 1 ', N'1', N'1', NULL, NULL, NULL, N'CDMX', NULL, 55018, N'19.987444, -99.33555', NULL, N'{"HorarioDesde":"13:00:00","HorarioHata":"16:10:00"}', N'{"CirculacionDesde":"13:20:00","CirculacionHasta":"13:25:00"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'{"Id":1,"Nombre":"Valaentin","Email":"valentin@gmail.com","Telefono":"1111111111","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":null,"Cada":null}', NULL, NULL, 1, CAST(N'2024-03-07T12:21:56.517' AS DateTime), N'[{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK0000HK","trail_notes":"Alta de Registro","trail_timemark":"2023-06-16T17:24:35.3646835+00:00"}]')
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (5, 5, N'Sonda', N'XAXX010101000', NULL, N'Son01', N'avenida', N'3', N'1', NULL, NULL, NULL, N'CDMX', NULL, 54094, N'19.988555, -99.13564', 1, N'{"HorarioDesde":"13:00:00","HorarioHata":"16:10:00"}', N'{"CirculacionDesde":"13:20:00","CirculacionHasta":"13:25:00"}', N'[{"Llave":1,"Valor":"Matachispas"}]', N'[{"Llave":1,"Valor":"Tipo 1"}]', N'[{"Llave":1,"Valor":"Habilidad 1"}]', N'[{"Llave":42,"Valor":"Formato de solicitud de constancia"}]', N'[{"Llave":6,"Valor":"Habilidad 6"}]', N'[{"Llave":42,"Valor":"Formato de solicitud de constancia"}]', N'[{"Llave":6,"Valor":"Fotografia de factura con firma"}]', N'[{"Llave":5,"Valor":"Fotografia de talon de embarque"}]', 1, N'[{"Checklist":2,"inicio":"2023-09-01T00:00:00-06:00","fin":"2023-09-16T00:00:00","ChecklistDisabled":false,"inicioDisabled":false,"finDisabled":false}]', N'{"Id":1,"Nombre":"Valaentin","Email":"valentin@gmail.com","Telefono":"1111111111","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":null,"Cada":null}', 12, N'usrPhoenixAdmin', 1, CAST(N'2024-03-07T12:21:56.523' AS DateTime), N'[{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK0000HK","trail_notes":"Alta de Registro","trail_timemark":"2023-06-16T17:25:22.6020757+00:00"}]')
INSERT [Clientes].[Destinatarios] ([Id], [ClienteId], [RazonSocial], [RFC], [AxaptaId], [Referencia], [Calle], [NumeroExterior], [NumeroInterior], [Colonia], [Localidad], [Municipio], [Estado], [Pais], [CodigoPostal], [Coordenadas], [RecepcionCita], [VentanaAtencion], [RestriccionCirculacion], [HabilidadVehiculo], [DocumentoVehiculo], [HabilidadOperador], [DocumentoOperador], [HabilidadAuxiliar], [DocumentoAuxiliar], [EvidenciaSalida], [EvidenciaLlegada], [Sellos], [Checklist], [Contacto], [Geolocalizacion], [TiempoParado], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (6, 1, N'Sams Sa de Cb', N'XAXX010101000', NULL, N'SAMS01', N'patio', N'9', N'5', NULL, NULL, NULL, N'CDMX', NULL, 55020, N'19.222222, -99.46546', NULL, N'{"HorarioDesde":"13:00:00","HorarioHata":"16:10:00"}', N'{"CirculacionDesde":"13:20:00","CirculacionHasta":"13:25:00"}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'{"Id":1,"Nombre":"Valaentin","Email":"valentin@gmail.com","Telefono":"1111111111","Puesto":"Empleado"}', N'{"notificar":true,"Geolocalizacion":null,"Cada":null}', NULL, NULL, 1, CAST(N'2024-03-07T12:21:56.460' AS DateTime), N'[{"trail_system_user":"AdministracionWMS02","trail_workstation":"DW1SDWK0000HK","trail_notes":"Alta de Registro","trail_timemark":"2023-06-16T17:26:21.6680572+00:00"}]')
GO
ALTER TABLE [Clientes].[Destinatarios]  WITH CHECK ADD  CONSTRAINT [FK_Destinatarios_Clientes] FOREIGN KEY([ClienteId])
REFERENCES [Clientes].[Clientes] ([Id])
GO
ALTER TABLE [Clientes].[Destinatarios] CHECK CONSTRAINT [FK_Destinatarios_Clientes]
GO
