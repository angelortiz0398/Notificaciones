using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Modelo.Entidades.Validacion
{
    public enum ValidadorEnum  
    {
        CustodioAsignado = 1,
        InfraccionRegistrada = 2,
        DíasInactividad = 3,
        AsignacionManifiesto = 4,
        AsignacionResguardo = 5,
        ComprobacionGastosPendiente = 6,
        ManifiestosAbiertos = 7,
        DocumentoPorVencerColaborador = 8,
        DocumentoVencidoColaborador = 9,
        ChecklistPorVencerColaborador = 10,
        ChecklistVencidoColaborador = 11,
        ManifiestosAbiertosExcedidos = 12,
        GastosNoComprobadosExcedidos = 13,
        MovimientoEnGastosOperativos = 14,
        NoCoincideNumeroSerieConSesionColaborador = 15,
        CreacionManifiesto = 16,
        CostoCombustibleDesactualizado = 17,
        TarifaProximaVencer = 18,
        TarifaVencida = 19,
        AsignacionDispersionMontoExcedido = 20,
        GastoExcedido = 21,
        MovimientoRestriccionHorario = 22,
        RestrasoInicioViaje = 23,
        RestrasoFinViaje = 24,
        ParadaPuntoNoAutorizado = 25,
        VehiculoAsignadoManifiestoNoPosiciona = 26,
        Geolocalizacion = 27,
        AperturaPuertaFueraDestino = 28,
        MovimientoVehiculoSinManifiesto = 29,
        VehiculoSinPosicionamiento = 30,
        TicketSinCosto = 31,
        CancelacionTicket = 32,
        ManifiestoForaneo = 33,
        ManifiestosAbiertosPorHoras = 34,
        RegistroTardioCustodia = 35,
        RetrasoTiempoCarga = 36,
        AsignacionColaboradorNoAutorizada = 37,
        AsignacionVehiculoNoAutorizada = 38,
        TicketNoEntregado = 39,
        ServicioRetrasado = 40,
        SeguroSocialRequerido = 41,
        ServicioOperadoTercero = 42,
        DocumentoPorVencerRemolque = 43,
        DocumentoVencidoRemolque = 44,
        ChecklistVencidoRemolque = 45,
        ChecklistPorVencerRemolque = 46,
        DocumentoPorVencerVehiculo = 47,
        ChecklistVencidoVehiculo = 48,
        ChecklistPorVencerVehiculo = 49,
        DocumentoVencidoVehiculo = 50
    }
}
