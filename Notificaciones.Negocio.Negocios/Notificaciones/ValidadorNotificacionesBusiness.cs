using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using Shared.Modelos;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class ValidadorNotificacionesBusiness : GenericBusiness<Notificacion>
    {
        private EnvioViajeBusiness EnvioViajeBusiness { get; set; } = new();

        public Respuesta ValidarNotificaciones(DateTime FechaHoraValidacion)
        {
            Respuesta respuesta = new("ValidarNotificaciones") { Status = 500, Message = "No se enviaron los parametros necesarios" };
            // Crea el objeto (business) con el que se revisaran las notificaciones y saber cuales estan prendidas
            INotificacionRepositorio NotificacionRepo = new NotificacionRepositorio(); 
            IGenericRepository<Notificacion> NotificacionGenericRepo = new GenericRepository<Notificacion>();
            NotificacionBusiness notificacionBusiness = new(NotificacionGenericRepo, NotificacionRepo);
            // Crea el objeto para ejecutar las validaciones de las notificaciones
            IValidadorNotificacionRepositorio ValidadorNotificacionRepo = new ValidadorNotificacionRepositorio(); 

            // Obtiene todas las notificaciones y filtra por aquellas que estan activas
            List<Notificacion> listaNotificaciones = notificacionBusiness.ObtenerTodos().Where(notificacion => notificacion.Activada == true).ToList();
            if (listaNotificaciones != null)
            {
                if (listaNotificaciones.Count > 0)
                {
                    // Recorre todas las notificaciones que esten activadas
                    listaNotificaciones.ForEach(notificacion =>
                    {
                        // Valida si la condicion para que se active la notificacion se esta cumpliendo
                        if (ValidadorNotificacionRepo.ValidarAlertamientoNotificacion(notificacion.Id))
                        {
                            // Deserializa la regla que existe en esta notificacion para saber cuantas veces se tiene que repetir y en que intervalo
                            Regla regla = !string.IsNullOrWhiteSpace(notificacion.Reglas) ? JsonConvert.DeserializeObject<Regla>(notificacion.Reglas) : new();
                            // Dependiendo de la repeticion en la que se encuentra y si el intervalo de tiempo es mayor que en la ultima ejecucion
                            if (regla.Aplazamiento.RepeticionActual < regla.Aplazamiento.Repeticiones
                                && FechaHoraValidacion > (regla.Aplazamiento.UltimaEjecucion + regla.Aplazamiento.Intervalo))
                            {
                                // Se crea la notificacion y su alerta
                                EnvioViajeBusiness.CreacionNotificacion(notificacion);
                            }
                        }
                    });
                    // Se actualiza el estatus de la respuesta y su mensaje
                    respuesta.Status = 200;
                    respuesta.Message = "Proceso ejecutado correctamente.";
                    respuesta.Function = "ValidarNotificaciones";
                    respuesta.timeMeasure.Stop();
                }
            }
            return respuesta;
        }
    }
}
