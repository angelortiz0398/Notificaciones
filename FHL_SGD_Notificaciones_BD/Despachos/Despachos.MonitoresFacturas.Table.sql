USE [SGD_V1]
GO
/****** Object:  Table [Despachos].[MonitoresFacturas]    Script Date: 11/03/2024 02:10:49 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Despachos].[MonitoresFacturas](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientesId] [bigint] NOT NULL,
	[DestinatariosId] [bigint] NULL,
	[DespachoId] [bigint] NULL,
	[TicketId] [bigint] NULL,
	[DetalleCosto] [varchar](max) NULL,
	[CostoOperativo] [numeric](18, 2) NULL,
	[GastoOperativo] [numeric](18, 2) NULL,
	[GastosIndirectos] [numeric](18, 2) NULL,
	[GastosNoJustificados] [numeric](18, 2) NULL,
	[Diferencia] [numeric](18, 2) NULL,
	[Estatus] [bit] NULL,
	[Usuario] [varchar](150) NULL,
	[Eliminado] [bit] NULL,
	[FechaCreacion] [datetime] NULL,
	[Trail] [varchar](max) NULL,
 CONSTRAINT [PK_MonitoresFacturas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[ClientesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
