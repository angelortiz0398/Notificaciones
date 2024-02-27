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

        /// <summary>
        /// Metodo para validar si existen notificaciones activadas y si hay alguna que se deba alertar
        /// </summary>
        /// <param name="FechaHoraValidacion"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso) o 500 (Error del servidor, tanto de la base de datos o de Twilio) </returns>
        public Respuesta ValidarNotificaciones(DateTime FechaHoraValidacion)
        {
            Console.WriteLine("Ejcucion de ValidarNotificaciones a las " + DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff"));
            Respuesta respuesta = new("ValidarNotificaciones") { Status = 400, Message = "No se enviaron los parametros necesarios" };
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
                    try
                    {
                        // Recorre todas las notificaciones que esten activadas
                        listaNotificaciones.ForEach(notificacion =>
                        {
                            // Valida si la condicion para que se active la notificacion se esta cumpliendo
                            if (ValidadorNotificacionRepo.ValidarAlertamientoNotificacion(out List<ListaContacto> objectArray, notificacion.Id))
                            {
                                // Deserializa la regla que existe en esta notificacion para saber cuantas veces se tiene que repetir y en que intervalo
                                Regla regla = !string.IsNullOrWhiteSpace(notificacion.Reglas) ? JsonConvert.DeserializeObject<Regla>(notificacion.Reglas) : new();
                                // Dependiendo de la repeticion en la que se encuentra y si el intervalo de tiempo es mayor que en la ultima ejecucion
                                if (regla.Aplazamiento.RepeticionActual < regla.Aplazamiento.Repeticiones
                                    && FechaHoraValidacion > (regla.Aplazamiento.UltimaEjecucion + regla.Aplazamiento.Intervalo))
                                {
                                    // Se crea la notificacion y su alerta
                                    Respuesta respuestaEnvioNotificacion = EnvioViajeBusiness.CreacionNotificacion(notificacion, objectArray);
                                    // En caso de que la notificacion no supere las validaciones (Este vacio la condiciones o la lista de contactos) o que fuera un error del servidor
                                    if (respuestaEnvioNotificacion.Status != 200)
                                    {
                                        // Se utiliza para capturar la data en las notificaciones que tenga error
                                        respuesta.Data = respuestaEnvioNotificacion.Data;
                                        respuesta.Message = respuestaEnvioNotificacion.Message;
                                    }
                                }
                            }
                        });
                        // Se actualiza el estatus de la respuesta y su mensaje
                        respuesta.Status = 200;
                        respuesta.Message = "Proceso ejecutado correctamente.";
                        respuesta.Function = "ValidarNotificaciones";
                        respuesta.timeMeasure.Stop();
                    }
                    catch (Exception)
                    {
                        respuesta.Status = 500;
                        respuesta.Message = "Falló ejecución del proceso.";
                        respuesta.Function = "ValidarNotificaciones";
                        respuesta.timeMeasure.Stop();
                    }
                }
            }
            return respuesta;
        }
    }
}
