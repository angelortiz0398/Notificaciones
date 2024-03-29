USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[ReasignaTickets]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[ReasignaTickets](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TicketId] [bigint] NOT NULL,
	[FechaReasignacion] [datetime] NULL,
	[ColaboradorAutorizoId] [int] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_ReasignaTickets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [Despachos].[ReasignaTickets] ON 

INSERT [Despachos].[ReasignaTickets] ([Id], [TicketId], [FechaReasignacion], [ColaboradorAutorizoId], [Usuario], [Eliminado], [FechaCreacion], [Trail]) VALUES (1, 1, CAST(N'2024-02-28T00:00:00.000' AS DateTime), NULL, N'usrphoenixadmin', 1, CAST(N'2023-11-15T17:05:03.457' AS DateTime), N'[{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Alta de Registro","trail_timemark":"2023-11-15T17:04:08.8414966-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-15T17:05:20.3412558-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-15T17:14:27.7915796-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2023-11-15T17:41:12.4802298-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-02T13:03:28.5448102-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-02T13:04:13.0143999-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-07T14:47:30.7566062-06:00"},{"trail_system_user":"roter","trail_workstation":"PHOENIX-A","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-09T18:04:29.7610429-06:00"},{"trail_system_user":"NewLa","trail_workstation":"OMAR_PHOENIX","trail_notes":"Actualización de Registro","trail_timemark":"2024-02-27T12:38:21.5843736-06:00"}]')
SET IDENTITY_INSERT [Despachos].[ReasignaTickets] OFF
GO
