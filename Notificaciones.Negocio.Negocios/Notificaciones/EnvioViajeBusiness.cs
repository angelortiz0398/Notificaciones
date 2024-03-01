using AdministracionSGD.Modelos.Despachos;
using Microsoft.Extensions.Configuration;
using Microsoft.JSInterop;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using SendGrid;
using SendGrid.Helpers.Mail;
using Shared.Modelos;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.TwiML.Messaging;
using Alerta = Notificaciones.Modelo.Entidades.Notificaciones.Alerta;
using Notificacion = Notificaciones.Modelo.Entidades.Notificaciones.Notificacion;
using PhoneNumber = Twilio.Types.PhoneNumber;

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
            string environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            IConfigurationBuilder builder = new ConfigurationBuilder()
                            .SetBasePath(AppContext.BaseDirectory)
                            .AddJsonFile($"appsettings.json", true, true)
                            .AddJsonFile($"appsettings.{environmentName}.json", true, true)
                            .AddEnvironmentVariables();

            Configuration = builder.Build();
            AccountSid = Configuration.GetSection("ApiURLS:accountSid").Value;
            AuthToken = Configuration.GetSection("ApiURLS:authToken").Value;
            NumeroServicio = Configuration.GetSection("ApiURLS:numeroServicio").Value;
            ApiKey = Configuration.GetSection("ApiURLS:SENDGRID_API_KEY").Value;
        }


        /// <summary>
        /// Metodo para el envio de notificaciones por diferentes medios
        /// </summary>
        /// <param name="request"></param>
        /// <param name="objectArray"></param>
        /// <param name="InformacionAdicional"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso), 400(Fallido por error del cliente, uno o varios campos quedaron vacios) o 500 (Error del servidor, tanto de la base de datos o de Twilio)</returns>
        public Respuesta CreacionNotificacion(Notificacion request, List<ListaContacto> objectArray = null, string InformacionAdicional = null)
        {
            Respuesta respuesta = new("CreacionNotificacion");
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
            if (listaContactos[0].Emails.Count == 0 && listaContactos[0].Phones.Count == 0 && listaContactos[0].Users.Count == 0)
            {
                respuesta.Status = 400;
                respuesta.Message = "La lista de contactos no tiene emails, ni teléfono, ni usuarios a quien notificar.";
                respuesta.Data = null;
                respuesta.timeMeasure.Stop();
                return respuesta;
            }

            // Proceso para juntar listaContactos con objectArray en listaContactos
            // objectArray es un parametro opcional que puede o no llegar pero debido a que la funcion CreacionNotificacion() se manda a llamar desde el ValidadorNotificacionesBusiness
            // este primero consulta el sp de cada una de las validaciones que esten activas y si trae una lista de contactos a los que se les debe alertar y un mensaje que deba decir la notifiacion 
            // Por ese motivo se juntan ambas listas en una sola. Por un lado tenemos request.ListaContactos que es la lista de contactos que se creo en la configuracion de notificaciones y por otro lado lo que regrese el sp
            if (objectArray != null)
            {
                if (objectArray.Count > 0)
                {
                    // Agrega los emails si es que existen
                    if (objectArray[0].Emails.Count > 0)
                    {
                        for (int i = 0; i < objectArray[0].Emails.Count; i++)
                        {
                            if (!string.IsNullOrWhiteSpace(objectArray[0].Emails[i].EmailAddress))
                            {
                                listaContactos[0].Emails.Add(objectArray[0].Emails[i]);
                            }
                        }
                    }
                    // Agrega los phones si es que existen
                    if (objectArray[0].Phones.Count > 0)
                    {
                        for (int i = 0; i < objectArray[0].Phones.Count; i++)
                        {
                            if (!string.IsNullOrWhiteSpace(objectArray[0].Phones[i].PhoneNumber))
                            {
                                listaContactos[0].Phones.Add(objectArray[0].Phones[i]);
                            }
                        }
                    }
                    // Agrega los users si es que existen
                    if (objectArray[0].Users.Count > 0)
                    {
                        for (int i = 0; i < objectArray[0].Users.Count; i++)
                        {
                            if (objectArray[0].Users[i].UserId != 0)
                            {
                                listaContactos[0].Users.Add(objectArray[0].Users[i]);
                            }
                        }
                    }
                }
            }

            /*
             * Deserializa el listado de notificaciones en un listado de string con el nombre de las notificaciones que se esperan realizar
            */
            NotificacionesLista notificacionesContainer = JsonConvert.DeserializeObject<NotificacionesLista>(request.Condiciones);

            List<string> notificaciones = [];
            foreach (NotificacionCadena notificacionCadena in notificacionesContainer.notificaciones)
            {
                notificaciones.Add(notificacionCadena.notificacion);
            }
            // Crea el objeto con el que se insertaran las alertas (Historico de notificaciones)
            IAlertaRepositorio AlertaRepo = new AlertaRepositorio(); // Por ejemplo
            IGenericRepository<Alerta> AlertaGenericRepo = new GenericRepository<Alerta>();
            AlertaBusiness alertaBusiness = new(AlertaGenericRepo, AlertaRepo);
            // Crea el objeto con el que se actualizara la notificacion
            INotificacionRepositorio NotificacionRepo = new NotificacionRepositorio();
            IGenericRepository<Notificacion> NotificacionGenericRepo = new GenericRepository<Notificacion>();
            NotificacionBusiness notificacionBusiness = new(NotificacionGenericRepo, NotificacionRepo);
            // Crea el objeto con el que se actualizara la Bandeja
            IBandejaRepositorio BandejaRepo = new BandejaRepositorio();
            IGenericRepository<Bandeja> BandejaGenericRepo = new GenericRepository<Bandeja>();
            BandejaBusiness bandejaBusiness = new(BandejaGenericRepo, BandejaRepo);
            // Se intenta hacer el proceso de enviar la notifiacion, crear la alerta y actualizar la notifiacion (por el tema de las reglas)
            try
            {
                /*
                 * Recorre la lista de notificaciones para realizar el envio de la notificacion que le corresponde
                */
                notificaciones.ForEach(notificacion =>
                {
                    // Se crea una alerta por cada tipo de notificacion
                    switch (notificacion)
                    {
                        case "email":
                            Console.WriteLine("Notificacion por email");
                            if (listaContactos[0].Emails.Count > 0)
                            {
                                string json = JsonConvert.SerializeObject(listaContactos[0].Emails);
                                Console.WriteLine("Lista contactos: " + json);
                                // Se recorre la lista de correos para enviar los emails usando una plantilla
                                listaContactos[0].Emails.ForEach(async (correo) =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(0, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    await Task.Delay(200);
                                    // Envia el correo electronico
                                    EnviarCorreoElectronico(request.Nombre, correo.EmailAddress.Trim(), InformacionAdicional);
                                });
                            }
                            break;
                        // Para el envio por user, inserta en la bandeja de notificaciones del usuario
                        case "user":
                            Console.WriteLine("Notificacion por user");
                            if (listaContactos[0].Users.Count > 0)
                            {
                                // Se recorre la lista de correos para enviar los emails usando una plantilla
                                listaContactos[0].Users.ForEach((usuario) =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(0, request.Nombre, request.Usuario, request.Trail, alertaBusiness);

                                    // Envia la notificacion a la bandeja del usuario
                                    EnviarBandeja(usuario.UserId, alertaGuardada, request.Usuario, request.Trail, bandejaBusiness);
                                });
                            }
                            break;
                        // Para el envio por push
                        case "push":
                            Console.WriteLine("Notificacion por push");
                            if (listaContactos[0].Users.Count > 0)
                            {
                                Alerta alertaGuardada = CrearAlerta(0, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                            }
                            break;
                        // Para el envio por whatsapp, usa Twilio
                        case "whatsapp":
                            Console.WriteLine("Notificacion por whatsapp");
                            if (listaContactos[0].Phones.Count > 0)
                            {
                                listaContactos[0].Phones.ForEach(async (telefono) =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(0, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    // Valida si el telefono tiene lada si no debe agregarla
                                    await Task.Delay(200);
                                    // Envia el mensaje por Whatsapp
                                    EnviarWhatsapp(AccountSid, AuthToken, request.Nombre, telefono.PhoneNumber.Trim(), InformacionAdicional);
                                });
                            }
                            break;
                        // Para el envio por sms, usa Twilio
                        case "sms":
                            Console.WriteLine("Notificacion por sms");
                            if (listaContactos[0].Phones.Count > 0)
                            {
                                listaContactos[0].Phones.ForEach(async (telefono) =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(0, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    // Valida si el telefono tiene lada si no debe agregarla
                                    await Task.Delay(200);
                                    // Envia el mensaje por SMS
                                    EnviarSMS(AccountSid, AuthToken, request.Nombre, telefono.PhoneNumber.Trim(), InformacionAdicional);
                                });
                            }
                            break;
                    }
                });

                // Se actualiza la notificacion cuya regla ahora estara modificada con la informacion actual de esta (repeticionActual y ultimaEjecucion)
                Regla regla = !string.IsNullOrWhiteSpace(request.Reglas) ? JsonConvert.DeserializeObject<Regla>(request.Reglas) : new();
                regla.Aplazamiento.RepeticionActual++;
                regla.Aplazamiento.UltimaEjecucion = DateTime.Now;
                // No se modifica el trail ya que podria haber notificaciones que se ejecuten permanentemente y este ir aumentando significativamente
                // Se modifica el campo reglas
                request.Reglas = JsonConvert.SerializeObject(regla);
                // Se actualiza la notificacion
                _ = notificacionBusiness.Actualizar(request);

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

        private static Alerta CrearAlerta(long Id, string Nombre, string Usuario, string Trail, AlertaBusiness alertaBusiness)
        {
            Alerta alerta = new()
            {
                Id = 0,
                NotificacionesId = Id,
                FechaCreacionAlerta = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff")),
                TextoAlerta = "Texto de alerta de " + Nombre,
                Usuario = Usuario,
                Trail = Trail
            };
            Alerta alertaGuardada = alertaBusiness.Insertar(alerta);
            return alertaGuardada;
        }

        private void EnviarSMS(string accountSid, string authToken, string TextoAlerta, string NumeroTelefonico, string InformacionExtra)
        {
            if (string.IsNullOrEmpty(accountSid))
            {
                throw new ArgumentException($"'{nameof(accountSid)}' no puede ser nulo ni estar vacío.", nameof(accountSid));
            }

            if (string.IsNullOrEmpty(authToken))
            {
                throw new ArgumentException($"'{nameof(authToken)}' no puede ser nulo ni estar vacío.", nameof(authToken));
            }
            string numeroFormato = NumeroTelefonico.StartsWith("521") ? $"+{NumeroTelefonico}" : $"+52{NumeroTelefonico}";
            TwilioClient.Init(AccountSid, AuthToken);
            MessageResource messageResource = MessageResource.Create(
                body: $"Por este medio se le notifica que tiene una alerta de notificación de '{TextoAlerta}’. Para mayor información ingrese a la plataforma.",
                from: new Twilio.Types.PhoneNumber($"+{NumeroServicio}"),
                to: new Twilio.Types.PhoneNumber($"+{numeroFormato}")
            );
            Console.WriteLine("messageResource: " + JsonConvert.SerializeObject(messageResource));
        }

        private void EnviarWhatsapp(string accountSid, string authToken, string TextoAlerta, string NumeroTelefonico, string InformacionExtra)
        {
            if (string.IsNullOrEmpty(accountSid))
            {
                throw new ArgumentException($"'{nameof(accountSid)}' no puede ser nulo ni estar vacío.", nameof(accountSid));
            }

            if (string.IsNullOrEmpty(authToken))
            {
                throw new ArgumentException($"'{nameof(authToken)}' no puede ser nulo ni estar vacío.", nameof(authToken));
            }

            string numeroFormato = NumeroTelefonico.StartsWith("521") ? $"whatsapp:+{NumeroTelefonico}" : $"whatsapp:+52{NumeroTelefonico}";
            TwilioClient.Init(AccountSid, AuthToken);
            CreateMessageOptions messageOptions = new(new PhoneNumber(numeroFormato))
            {
                From = new PhoneNumber($"whatsapp:+{NumeroServicio}"),
                Body = $"Por este medio se le notifica que tiene una alerta de notificación de '*{TextoAlerta}*'. \n {InformacionExtra} \n Para mayor información ingrese a la plataforma.",
                MediaUrl = []
            };
            var response = MessageResource.Create(messageOptions);
            Console.WriteLine("response: " + JsonConvert.SerializeObject(response));
        }

        private void EnviarCorreoElectronico(string TextoNotificacion, string CorreoElectronico, string InformacionExtra)
        {
            // Se crea el cliente para sendGrid
            SendGridClient client = new(ApiKey);
            // Se usa el correo destinado para esto
            EmailAddress from = new("angelortiz0398@gmail.com", "Grupo FH");
            string subject = $"Alertamiento de {TextoNotificacion}";
            EmailAddress to = new(CorreoElectronico);
            string plainTextContent = "Alertamiento usando servicios de Twilio.";
            // Ruta del archivo HTML
            string rutaArchivo = @"..\FHL_SGD_Notificaciones_Api\Shared\AssetEmail.html";

            // Lee el contenido del archivo HTML y lo almacena en una cadena de texto
            string contenidoHTML = File.ReadAllText(rutaArchivo);
            contenidoHTML = contenidoHTML.Replace("{{TextAlert}}", $"Por este medio se le notifica que tiene una alerta de notificación de '{TextoNotificacion}'. <br /> {InformacionExtra} <br /> Para mayor información ingrese a la plataforma.");
            SendGridMessage msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, contenidoHTML);
            // Se envia el email
            var response = client.SendEmailAsync(msg);
        }

        private static void EnviarBandeja(long UsuarioId, Alerta AlertaGuardada, string Usuario, string Trail, BandejaBusiness bandejaBusiness)
        {
            Bandeja bandeja = new()
            {
                Id = 0,
                ColaboradoresId = UsuarioId,
                AlertasId = AlertaGuardada.Id,
                FechaCreacionAlerta = Convert.ToDateTime(AlertaGuardada.FechaCreacionAlerta.ToString("yyyy-MM-ddTHH:mm:ss.fff")),
                FechaLlegada = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff")),
                Lectura = false,
                Usuario = Usuario,
                Trail = Trail
            };
            _ = bandejaBusiness.Insertar(bandeja);
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
