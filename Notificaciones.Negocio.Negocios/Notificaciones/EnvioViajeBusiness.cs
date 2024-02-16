using Microsoft.Extensions.Configuration;
using Microsoft.JSInterop;
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
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using PhoneNumber = Twilio.Types.PhoneNumber;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class EnvioViajeBusiness : GenericBusiness<Notificacion>
    {
        protected IConfigurationRoot _configuration { get; set; }
        protected IJSRuntime _runtime { get; set; }
        private string accountSid { get; set; }
        private string authToken { get; set; }
        private string numeroServicio { get; set; }

        public EnvioViajeBusiness()
        {
            var environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            var builder = new ConfigurationBuilder()
                            .SetBasePath(AppContext.BaseDirectory)
                            .AddJsonFile($"appsettings.json", true, true)
                            .AddJsonFile($"appsettings.{environmentName}.json", true, true)
                            .AddEnvironmentVariables();

            _configuration = builder.Build();
            this.accountSid = _configuration.GetSection("ApiURLS:accountSid").Value;
            this.authToken = _configuration.GetSection("ApiURLS:authToken").Value;
            this.numeroServicio = _configuration.GetSection("ApiURLS:numeroServicio").Value;
        }

        /// <summary>
        /// Metodo para el envio de notificaciones por diferentes medios
        /// </summary>
        /// <param name="notificacion"></param>
        /// <returns></returns>
        public Respuesta CreacionNotificacion(Notificacion request)
        {
            Respuesta respuesta = new Respuesta("CreacionNotificacion");

            /*
             * Valida si el campo Condiciones y ListaContactos no viene vacio, si es asi retorna con una respuesta de error
            */
            if (string.IsNullOrWhiteSpace(request.Condiciones) || string.IsNullOrWhiteSpace(request.ListaContactos))
            {
                respuesta.Status = 500;
                respuesta.Message = "No se adjuntó una lista de contactos o los medios para enviar las notificaciones.";
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

            /*
             * Recorre la lista de notificaciones para realizar el envio de la notificacion que le corresponde
            */
            notificaciones.ForEach(notificacion =>
            {
                switch (notificacion)
                {
                    case "email":
                        Console.WriteLine("Hola mundo");
                        break;
                    case "user":
                        break;                    
                    case "whatsapp":
                        string numeroFormato = $"whatsapp:+525584935123";

                        TwilioClient.Init(accountSid, authToken);
                        var messageOptions = new CreateMessageOptions(new PhoneNumber(numeroFormato));
                        messageOptions.From = new PhoneNumber($"whatsapp:+{numeroServicio}");
                        messageOptions.Body = "Prueba con Whatsapp";
                        messageOptions.MediaUrl = new List<Uri> { };
                        var message = MessageResource.Create(messageOptions);
                        break;
                    case "sms":
                        TwilioClient.Init(accountSid, authToken);

                        var messageResource = MessageResource.Create(
                            body: "Prueba con SMS",
                            from: new Twilio.Types.PhoneNumber($"+12137725593"),
                            to: new Twilio.Types.PhoneNumber($"+{numeroServicio}")
                        );
                        break;
                }
                Alerta alerta = new()
                {
                    Id = 0,
                    NotificacionesId = request.Id,
                    FechaCreacionAlerta = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff")),
                    TextoAlerta = request.Nombre,
                    Usuario = request.Usuario,
                    Trail = request.Trail
                };
                var bandejas = bandejaBusiness.Insertar(alerta);
            });

            respuesta.Data = request;
            respuesta.timeMeasure.Stop();
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
