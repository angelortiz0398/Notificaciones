﻿using Newtonsoft.Json;
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
        public Respuesta ValidarNotificaciones(DateTime FechaHoraValidacion)
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
            if (listaNotificaciones != null)
            {
                if (listaNotificaciones.Count > 0)
                {
                    try
                    {
                        // Recorre todas las notificaciones que esten activadas
                        listaNotificaciones.ForEach(notificacion =>
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
                                    Respuesta respuestaEnvioNotificacion = EnvioViajeBusiness.CreacionNotificacion(notificacion, objectArray, InformacionAdicional);
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
                        respuesta.Data = listaNotificaciones;
                        respuesta.Function = "ValidarNotificaciones";
                        respuesta.timeMeasure.Stop();
                    }
                    catch (Exception ex)
                    {
                        // Si fallo la ejecucion de algun sp o de un servicio de Twilio
                        respuesta.Status = 500;
                        respuesta.Message = $"Falló ejecución del proceso: {ex.Message}";
                        respuesta.Function = "ValidarNotificaciones";
                        respuesta.Data = ex.Data;
                        respuesta.timeMeasure.Stop();
                    }
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
