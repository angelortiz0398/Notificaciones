using Azure;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class ValidadorNotificacionesBusiness : GenericBusiness<Notificacion>
    {
        private EnvioNotificacionBusiness EnvioViajeBusiness { get; set; } = new();

        /// <summary>
        /// Metodo para validar si existen notificaciones activadas y si hay alguna que se deba alertar
        /// </summary>
        /// <param name="FechaHoraValidacion"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso) o 500 (Error del servidor, tanto de la base de datos o de Twilio) </returns>
        public async Task<Respuesta> ValidarNotificaciones(DateTime FechaHoraValidacion)
        {
            Console.WriteLine("Ejcucion de ValidarNotificaciones a las " + FechaHoraValidacion.ToString("yyyy-MM-ddTHH:mm:ss.fff"));
            Respuesta respuesta = new("ValidarNotificaciones") { Status = 500, Message = "Error en el servidor." };
            // Crea el objeto (business) con el que se revisaran las notificaciones y saber cuales estan prendidas
            INotificacionRepositorio NotificacionRepo = new NotificacionRepositorio();
            IGenericRepository<Notificacion> NotificacionGenericRepo = new GenericRepository<Notificacion>();
            NotificacionBusiness notificacionBusiness = new(NotificacionGenericRepo, NotificacionRepo);
            // Crea el objeto para ejecutar las validaciones de las notificaciones
            IValidadorNotificacionRepositorio ValidadorNotificacionRepo = new ValidadorNotificacionRepositorio();

            // Obtiene todas las notificaciones y filtra por aquellas que estan activas
            List<Notificacion> listaNotificaciones = notificacionBusiness.ObtenerTodos().Select(notificacion => notificacion).Where(n => n.Activada == true).ToList();
            List<Respuesta> AcumulacionRespuestas = [];
            List<Respuesta> AcumulacionRespuestasFallidas = [];

            if (listaNotificaciones != null)
            {
                if (listaNotificaciones.Count > 0)
                {
                    // Recorre todas las notificaciones que esten activadas
                    await Task.Run(async () =>
                    {
                        for (int i = 0; i < listaNotificaciones.Count; i++)
                        {
                            var notificacion = listaNotificaciones[i];
                            // Usa un bloque try catch por si falla alguna en concreto y permitir el flujo de las demas alertamientos
                            // Se encuentra dentro del ForEach para que el flujo del programa no se detenga y continuar procesando las siguientes notificaciones
                            try
                            {
                                // Deserializa la regla que existe en esta notificacion para saber cuantas veces se tiene que repetir y en que intervalo
                                Regla regla = !string.IsNullOrWhiteSpace(notificacion.Reglas) ? JsonConvert.DeserializeObject<Regla>(notificacion.Reglas) : new();
                                // Valida si la condicion para que se active la notificacion se esta cumpliendo
                                // objectArray: Es un Lista de NotificacionesLista que puede o no llegar, dependiendo del sp validador. Algunos sp no tienen de donde obtener la informacion del contacto como telefono, correo y Id del colaborador
                                // InformacionAdicional: Representa un mensaje especifico o personalizado que proviene del sp para colocar ea alerta
                                bool ValidacionAlertamiento = ValidadorNotificacionRepo.ValidarAlertamientoNotificacion(out List<ListaContacto> objectArray, out string InformacionAdicional, notificacion.Id, (TimeSpan)regla.Aplazamiento.Intervalo);
                                if (ValidacionAlertamiento)
                                {
                                    // Dependiendo de la repeticion en la que se encuentra y si el intervalo de tiempo es mayor que en la ultima ejecucion
                                    if (regla.Aplazamiento.RepeticionActual < regla.Aplazamiento.Repeticiones
                                            && FechaHoraValidacion > (regla.Aplazamiento.UltimaEjecucion + regla.Aplazamiento.Intervalo))
                                    {
                                        // Se crea la notificacion y su alerta
                                        Respuesta respuestaEnvioNotificacion = await EnvioViajeBusiness.CreacionNotificacion(notificacion, objectArray, InformacionAdicional);
                                        // Se agrega el resultado de cada respuesta.
                                        // Recordando que se hace el proceso de CreacionNotificacion por cada Notificacion que se encuentra activada
                                        AcumulacionRespuestas.Add(respuestaEnvioNotificacion);
                                    }
                                }
                            }
                            catch (Exception ex)
                            {
                                // Si fallo la ejecucion de algun sp o de un servicio de Twilio
                                AcumulacionRespuestasFallidas.Add(new Respuesta
                                {
                                    Status = 500,
                                    Message = $"Falló ejecución del proceso de la notificacion con Id: {notificacion.Id} y Nombre: {notificacion.Nombre}. ",
                                    Function = "ValidarNotificaciones",
                                    Data = $" Message: {ex.Message}, Data: {ex.Data}"
                                });
                            }
                        }

                        // Valida si hubo alguna respuesta con estatus 500
                        if (AcumulacionRespuestas.Exists(respuesta => respuesta.Status == 500) || AcumulacionRespuestas.Exists(respuesta => respuesta.Status == 400))
                        {
                            // Si no, devuelve en la data un listado de strings con los mensajes indicando cual es el Id y Nombre de la notificacion que fallo.
                            respuesta.Status = 500;
                            respuesta.Message = "Alguna de las notificaciones fallo en su ejecucion";
                            respuesta.Data = AcumulacionRespuestas.Select(notificacionesFaliida => notificacionesFaliida.Data).ToList();
                            respuesta.Function = "ValidarNotificaciones";
                            respuesta.timeMeasure.Stop();
                        }
                        else
                        {
                            // Se actualiza el estatus de la respuesta y su mensaje
                            respuesta.Status = 200;
                            respuesta.Message = "Proceso ejecutado correctamente.";
                            respuesta.Data = AcumulacionRespuestas;
                            respuesta.Function = "ValidarNotificaciones";
                            respuesta.timeMeasure.Stop();
                        }
                    });
                }
                else
                {
                    // Si no hay ninguna notificacion activada
                    respuesta.Status = 200;
                    respuesta.Message = "No hay notificaciones activadas qué alertar.";
                    respuesta.Data = listaNotificaciones;
                    respuesta.timeMeasure.Stop();
                }
            }
            return respuesta;
        }
    }
}
