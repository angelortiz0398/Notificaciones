USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[TicketsNoEntregados]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[TicketsNoEntregados](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[DespachoId] [bigint] NOT NULL,
	[FolioDespacho] [varchar](20) NOT NULL,
	[TicketId] [bigint] NOT NULL,
	[FolioTicket] [varchar](20) NOT NULL,
	[PrioridadId] [bigint] NULL,
	[TipoEntregaId] [bigint] NULL,
	[Reintentos] [int] NULL,
	[Restantes] [int] NULL,
	[CausaCambioId] [bigint] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_TicketsNoEntregados] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[TicketsNoEntregados] ON 

INSERT [Despachos].[TicketsNoEntregados] ([Id], [DespachoId], [FolioDespacho], [TicketId], [FolioTicket], [PrioridadId], [TipoEntregaId], [Reintentos], [Restantes], [CausaCambioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 6, N'', 20036, N'00000099', 1, 1, 3, 0, 1, N'phoenix', 1, CAST(N'2024-03-06T00:00:00.000' AS DateTime), N'[{"trail_system_user": "PHOENIX","trail_workstation": "PHOENIX","trail_notes": "Alta de Registro","trail_timemark": "2023-11-23 12:38:21.967702-06"}]')
INSERT [Despachos].[TicketsNoEntregados] ([Id], [DespachoId], [FolioDespacho], [TicketId], [FolioTicket], [PrioridadId], [TipoEntregaId], [Reintentos], [Restantes], [CausaCambioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (8, 7, N'23', 20036, N'00000099', NULL, 1, 3, 0, 2, N'phoenix', 1, NULL, N'[{"trail_system_user": "PHOENIX","trail_workstation": "PHOENIX","trail_notes": "Alta de Registro","trail_timemark": "2023-11-23 12:38:21.967702-06"}]')
INSERT [Despachos].[TicketsNoEntregados] ([Id], [DespachoId], [FolioDespacho], [TicketId], [FolioTicket], [PrioridadId], [TipoEntregaId], [Reintentos], [Restantes], [CausaCambioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (14, 5, N'23', 20036, N'00000099', NULL, NULL, 3, 0, 2, N'phoenix', 1, CAST(N'2024-01-16T00:00:00.000' AS DateTime), N'[{"trail_system_user": "PHOENIX","trail_workstation": "PHOENIX","trail_notes": "Alta de Registro","trail_timemark": "2023-11-23 12:38:21.967702-06"}]')
INSERT [Despachos].[TicketsNoEntregados] ([Id], [DespachoId], [FolioDespacho], [TicketId], [FolioTicket], [PrioridadId], [TipoEntregaId], [Reintentos], [Restantes], [CausaCambioId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (15, 1, N'm120', 70153, N'00000465', NULL, NULL, 1, 2, 1, N'ElValentin', 1, CAST(N'2024-02-29T15:01:59.543' AS DateTime), N'[{"trail_system_user": "PHOENIX","trail_workstation": "PHOENIX","trail_notes": "Alta de Registro","trail_timemark": "2023-11-23 12:38:21.967702-06"}]')
SET IDENTITY_INSERT [Despachos].[TicketsNoEntregados] OFF
GO
ALTER TABLE [Despachos].[TicketsNoEntregados]  WITH CHECK ADD  CONSTRAINT [FK_TicketsNoEntregados_CausasCambios] FOREIGN KEY([CausaCambioId])
REFERENCES [Despachos].[CausasCambios] ([Id])
GO
ALTER TABLE [Despachos].[TicketsNoEntregados] CHECK CONSTRAINT [FK_TicketsNoEntregados_CausasCambios]
GO
ALTER TABLE [Despachos].[TicketsNoEntregados]  WITH CHECK ADD  CONSTRAINT [FK_TicketsNoEntregados_Despachos] FOREIGN KEY([DespachoId])
REFERENCES [Despachos].[Despachos] ([Id])
GO
ALTER TABLE [Despachos].[TicketsNoEntregados] CHECK CONSTRAINT [FK_TicketsNoEntregados_Despachos]
GO
