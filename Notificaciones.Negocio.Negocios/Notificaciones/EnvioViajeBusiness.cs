using Microsoft.Extensions.Configuration;
using Microsoft.JSInterop;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using SendGrid.Helpers.Mail;
using SendGrid;
using Shared.Modelos;
using System;
using System.Collections.Generic;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Alerta = Notificaciones.Modelo.Entidades.Notificaciones.Alerta;
using Notificacion = Notificaciones.Modelo.Entidades.Notificaciones.Notificacion;
using PhoneNumber = Twilio.Types.PhoneNumber;
using System.IO;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class EnvioViajeBusiness : GenericBusiness<Notificacion>
    {
        protected IConfigurationRoot Configuration { get; set; }
        protected IJSRuntime Runtime { get; set; }
        private string AccountSid { get; set; }
        private string AuthToken { get; set; }
        private string NumeroServicio { get; set; }
        private string ApiKey { get; set; }


        /// <summary>
        /// Se obtiene la informacion para el consumo de la api de Twilio desde los appsettings
        /// </summary>
        public EnvioViajeBusiness()
        {
            var environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            var builder = new ConfigurationBuilder()
                            .SetBasePath(AppContext.BaseDirectory)
                            .AddJsonFile($"appsettings.json", true, true)
                            .AddJsonFile($"appsettings.{environmentName}.json", true, true)
                            .AddEnvironmentVariables();

            Configuration = builder.Build();
            this.AccountSid = Configuration.GetSection("ApiURLS:accountSid").Value;
            this.AuthToken = Configuration.GetSection("ApiURLS:authToken").Value;
            this.NumeroServicio = Configuration.GetSection("ApiURLS:numeroServicio").Value;
            this.ApiKey = Configuration.GetSection("ApiURLS:SENDGRID_API_KEY").Value;
        }

        /// <summary>
        /// Metodo para el envio de notificaciones por diferentes medios
        /// </summary>
        /// <param name="notificacion"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso), 400(Fallido por error del cliente, uno o varios campos quedaron vacios) o 500 (Error del servidor, tanto de la base de datos o de Twilio) </returns>
        public Respuesta CreacionNotificacion(Notificacion request)
        {
            Respuesta respuesta = new Respuesta("CreacionNotificacion");
            /*
             * Valida si el campo Condiciones y ListaContactos no viene vacio, si es asi retorna con una respuesta de error
            */
            if (string.IsNullOrWhiteSpace(request.Condiciones) || string.IsNullOrWhiteSpace(request.ListaContactos))
            {
                respuesta.Status = 400;
                respuesta.Message = "No se adjuntó una lista de contactos o los medios para enviar las notificaciones.";
                respuesta.Data = null;
                respuesta.timeMeasure.Stop();
                return respuesta;
            }
            /*
             * El campo ListaContactos viene por defecto asi: [{"emails":[],"phones":[],"users":[]}]
             * Valida si el campo ListaContactos tenga al menos un correo o un telefono al que notificar
             */
            List<ListaContacto> listaContactos = JsonConvert.DeserializeObject<List<ListaContacto>>(request.ListaContactos);
            if (listaContactos[0].Emails.Count == 0 && listaContactos[0].Phones.Count == 0)
            {
                respuesta.Status = 400;
                respuesta.Message = "La lista de contactos no tiene emails, ni teléfono, ni usuarios a quien notificar.";
                respuesta.Data = null;
                respuesta.timeMeasure.Stop();
                return respuesta;
            }

            /*
             * Deserializa el listado de notificaciones en un listado de string con el nombre de las notificaciones que se esperan realizar
            */
            NotificacionesLista notificacionesContainer = JsonConvert.DeserializeObject<NotificacionesLista>(request.Condiciones);

            List<string> notificaciones = new List<string>();
            foreach (NotificacionCadena notificacionCadena in notificacionesContainer.notificaciones)
            {
                notificaciones.Add(notificacionCadena.notificacion);
            }
            // Crea el objeto con el que se insertaran las alertas (Historico de notificaciones)
            IAlertaRepositorio AlertaRepo = new AlertaRepositorio(); // Por ejemplo
            IGenericRepository<Alerta> AlertaGenericRepo = new GenericRepository<Alerta>();
            AlertaBusiness bandejaBusiness = new(AlertaGenericRepo, AlertaRepo);
            // Crea el objeto con el que se actualizara la notificacion
            INotificacionRepositorio NotificacionRepo = new NotificacionRepositorio();
            IGenericRepository<Notificacion> NotificacionGenericRepo = new GenericRepository<Notificacion>();
            NotificacionBusiness notificacionBusiness = new(NotificacionGenericRepo, NotificacionRepo);
            // Se intenta hacer el proceso de enviar la notifiacion, crear la alerta y actualizar la notifiacion (por el tema de las reglas)
            try
            {
                /*
                 * Recorre la lista de notificaciones para realizar el envio de la notificacion que le corresponde
                */
                notificaciones.ForEach(notificacion =>
                {
                    switch (notificacion)
                    {
                        case "email":
                            // Se recorre la lista de correos para enviar los emails usando una plantilla
                            listaContactos[0].Emails.ForEach((emails) =>
                            {
                                Console.WriteLine("Notificacion por email");
                                // Se crea el cliente para sendGrid
                                var client = new SendGridClient(ApiKey);
                                // Se usa el correo destinado para esto
                                var from = new EmailAddress("angel@newlandapps.com", "Grupo FH");
                                var subject = $"Alertamiento de {request.Nombre}";
                                var to = new EmailAddress(emails.EmailAddress);
                                var plainTextContent = "Alertamiento usando servicios de Twilio.";
                                // Ruta del archivo HTML
                                string rutaArchivo = @"..\FHL_SGD_Notificaciones_Api\Shared\AssetEmail.html";

                                // Lee el contenido del archivo HTML y lo almacena en una cadena de texto
                                string contenidoHTML = File.ReadAllText(rutaArchivo);
                                contenidoHTML = contenidoHTML.Replace("{{TextAlert}}", $"Por este medio se le notifica que tiene una alerta de notificación '{request.Nombre}'. <br /> Para mayor información ingrese a la plataforma.");
                                var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, contenidoHTML);
                                // Se envia el email
                                var response = client.SendEmailAsync(msg);
                            });
                            break;
                        // Para el envio por user, inserta en la bandeja de notificaciones del usuario
                        case "user":
                            Console.WriteLine("Notificacion por user");
                            break;
                        // Para el envio por push
                        case "push":
                            Console.WriteLine("Notificacion por push");
                            break;
                        // Para el envio por whatsapp, usa Twilio
                        case "whatsapp":
                            string numeroFormato = $"whatsapp:+525584935123";

                            TwilioClient.Init(AccountSid, AuthToken);
                            var messageOptions = new CreateMessageOptions(new PhoneNumber(numeroFormato));
                            messageOptions.From = new PhoneNumber($"whatsapp:+{NumeroServicio}");
                            messageOptions.Body = "Prueba con Whatsapp";
                            messageOptions.MediaUrl = [];
                            var message = MessageResource.Create(messageOptions);
                            break;
                        // Para el envio por sms, usa Twilio
                        case "sms":
                            TwilioClient.Init(AccountSid, AuthToken);

                            var messageResource = MessageResource.Create(
                                body: "Prueba con SMS",
                                from: new Twilio.Types.PhoneNumber($"+12137725593"),
                                to: new Twilio.Types.PhoneNumber($"+{NumeroServicio}")
                            );
                            break;
                    }

                    // Se crea una alerta por cada tipo de notificacion
                    Alerta alerta = new()
                    {
                        Id = 0,
                        NotificacionesId = request.Id,
                        FechaCreacionAlerta = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff")),
                        TextoAlerta = "Texto de alerta de " + request.Nombre,
                        Usuario = request.Usuario,
                        Trail = request.Trail
                    };
                    var bandejas = bandejaBusiness.Insertar(alerta);
                });

                // Se actualiza la notificacion cuya regla ahora estara modificada con la informacion actual de esta (repeticionActual y ultimaEjecucion)
                Regla regla = !string.IsNullOrWhiteSpace(request.Reglas) ? JsonConvert.DeserializeObject<Regla>(request.Reglas) : new();
                regla.Aplazamiento.RepeticionActual++;
                regla.Aplazamiento.UltimaEjecucion = DateTime.Now;
                // No se modifica el trail ya que podria haber notificaciones que se ejecuten permanentemente y este ir aumentando significativamente
                // Se modifica el campo reglas
                request.Reglas = JsonConvert.SerializeObject(regla);
                // Se actualiza la notificacion
                notificacionBusiness.Actualizar(request);

                respuesta.Status = 200;
                respuesta.Message = "El proceso se ejecutó correctamente.";
                respuesta.Data = request;
                respuesta.timeMeasure.Stop();

            }
            catch (Exception ex)
            {
                respuesta.Status = 500;
                respuesta.Message = $"Message: {ex.Message}, StackTrace: {ex.StackTrace}, Data: {ex.Data}";
                respuesta.Data = request;
                respuesta.timeMeasure.Stop();
            }

            return respuesta;
        }
    }

    public class NotificacionesLista
    {
        [JsonProperty(nameof(notificaciones))]
        public List<NotificacionCadena> notificaciones { get; set; }
    }

    public class NotificacionCadena
    {
        [JsonProperty(nameof(notificacion))]
        public string notificacion { get; set; }
    }
}
