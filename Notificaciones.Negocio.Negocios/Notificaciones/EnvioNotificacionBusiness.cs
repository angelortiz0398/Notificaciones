using FirebaseAdmin.Messaging;
using Microsoft.Extensions.Configuration;
using Microsoft.JSInterop;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Twilio;
using Twilio.Exceptions;
using Twilio.Rest.Api.V2010.Account;
using Alerta = Notificaciones.Modelo.Entidades.Notificaciones.Alerta;
using Notificacion = Notificaciones.Modelo.Entidades.Notificaciones.Notificacion;
using PhoneNumber = Twilio.Types.PhoneNumber;
using Task = System.Threading.Tasks.Task;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class EnvioNotificacionBusiness : GenericBusiness<Notificacion>
    {
        protected IConfigurationRoot Configuration { get; set; }
        protected IJSRuntime Runtime { get; set; }
        private string AccountSid { get; set; }
        private string AuthToken { get; set; }
        private string NumeroServicio { get; set; }
        private string ApiKey { get; set; }
        private string FireBaseToken { get; set; }
        private string Email { get; set; }
        private int Errores { get; set; } = 0;
        List<Respuesta> RespuestasFallidas { get; set; } = [];



        /// <summary>
        /// Se obtiene la informacion para el consumo de la api de Twilio desde los appsettings
        /// </summary>
        public EnvioNotificacionBusiness()
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
            FireBaseToken = Configuration.GetSection("ApiURLS:FireBaseToken").Value;
            Email = Configuration.GetSection("ApiURLS:Email").Value;
        }


        /// <summary>
        /// Metodo para el envio de notificaciones por diferentes medios
        /// </summary>
        /// <param name="request"></param>
        /// <param name="objectArray"></param>
        /// <param name="InformacionAdicional"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso), 400(Fallido por error del cliente, uno o varios campos quedaron vacios) o 500 (Error del servidor, tanto de la base de datos o de Twilio)</returns>
        public async Task<Respuesta> CreacionNotificacion(Notificacion request, List<ListaContacto> objectArray = null, string InformacionAdicional = null)
        {
            Respuesta respuesta = new("CreacionNotificacion");
            /*
             * Valida si el campo Condiciones y ListaContactos no viene vacio, si es asi retorna con una respuesta de error
            */
            if (string.IsNullOrWhiteSpace(request.Condiciones) || string.IsNullOrWhiteSpace(request.ListaContactos))
            {
                respuesta.Status = 400;
                respuesta.Message = "No se adjuntó una lista de contactos o los medios para enviar las notificaciones.";
                respuesta.Data = "No se adjuntó una lista de contactos o los medios para enviar las notificaciones.";
                respuesta.timeMeasure.Stop();
                Errores++;
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
                respuesta.Data = "La lista de contactos no tiene emails, ni teléfono, ni usuarios a quien notificar.";
                respuesta.timeMeasure.Stop();
                Errores++;
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
                    if (objectArray[0].Emails != null)
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
                    }
                    // Agrega los phones si es que existen
                    if (objectArray[0].Phones != null)
                    {
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
                    }
                    // Agrega los users si es que existen
                    if (objectArray[0].Users != null)
                    {
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
            IGenericRepository<Modelo.Entidades.Notificaciones.Bandeja> BandejaGenericRepo = new GenericRepository<Modelo.Entidades.Notificaciones.Bandeja>();
            BandejaBusiness bandejaBusiness = new(BandejaGenericRepo, BandejaRepo);

            // Creacion de la variable que instancia a las tareas, de modo que se declaran las tareas y consumo de diferentes API pero no se esperan a que terminan
            // Para que el funcionamiento del flujo sea asincrono. 
            List<Task> TareasNotificaciones = [];
            // Se intenta hacer el proceso de enviar la notifiacion, crear la alerta y actualizar la notifiacion (por el tema de las reglas)
            /*
             * Recorre la lista de notificaciones para realizar el envio de la notificacion que le corresponde
            */
            notificaciones.ForEach(notificacion =>
            {
                // Usa un bloque try catch por si en algun medio de comunicacion falla (Twilio o Firebase) y permitir el flujo de las demas alertamientos
                // Se encuentra dentro del ForEach para que el flujo del programa no se detenga y continuar procesando las siguientes alertas
                try
                {
                    // Se crea una alerta por cada tipo de notificacion
                    switch (notificacion)
                    {
                        case "email":
                            Console.WriteLine("Notificacion por email");
                            if (listaContactos[0].Emails.Count > 0)
                            {
                                // Se recorre la lista de correos para enviar los emails usando una plantilla
                                listaContactos[0].Emails.ForEach(correo =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(request.Id, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    Task tareaCorreoElectronico = Task.Run(() =>
                                        EnviarCorreoElectronico(request.Nombre, correo.EmailAddress.Trim(), InformacionAdicional)
                                    );
                                    TareasNotificaciones.Add(tareaCorreoElectronico);
                                }
                                );

                            }
                            break;
                        // Para el envio por user, inserta en la bandeja de notificaciones del usuario
                        case "user":
                            Console.WriteLine("Notificacion por user");
                            if (listaContactos[0].Users.Count > 0)
                            {
                                // Se recorre la lista de correos para enviar los emails usando una plantilla
                                listaContactos[0].Users.ForEach(usuario =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(request.Id, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    Task.Delay(100);
                                    Task tareaBandeja = Task.Run(() => EnviarBandeja(usuario.UserId, alertaGuardada, request.Usuario, request.Trail, bandejaBusiness)
                                    );
                                    TareasNotificaciones.Add(tareaBandeja);
                                });
                            }
                            break;
                        // Para el envio por push
                        case "push":
                            Console.WriteLine("Notificacion por push");
                            if (listaContactos[0].Users.Count > 0)
                            {
                                Alerta alertaGuardada = CrearAlerta(request.Id, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                string texto = $"Por este medio se le notifica que tiene una alerta de {request.Nombre}. Para mayor información ingrese a la plataforma";
                                Task tareaPushNotification = Task.Run(() =>
                                {
                                    EnviarPushNotificacion(request.Nombre, texto);
                                });
                                TareasNotificaciones.Add(tareaPushNotification);
                            }
                            break;
                        // Para el envio por whatsapp, usa Twilio
                        case "whatsapp":
                            Console.WriteLine("Notificacion por whatsapp");
                            if (listaContactos[0].Phones.Count > 0)
                            {
                                listaContactos[0].Phones.ForEach(telefono =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(request.Id, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    Task tareaWhatsapp = Task.Run(() => EnviarWhatsapp(request.Nombre, telefono.PhoneNumber.Trim(), InformacionAdicional));
                                    TareasNotificaciones.Add(tareaWhatsapp);
                                });
                            }
                            break;
                        // Para el envio por sms, usa Twilio
                        case "sms":
                            Console.WriteLine("Notificacion por sms");
                            if (listaContactos[0].Phones.Count > 0)
                            {
                                listaContactos[0].Phones.ForEach(telefono =>
                                {
                                    Alerta alertaGuardada = CrearAlerta(request.Id, request.Nombre, request.Usuario, request.Trail, alertaBusiness);
                                    Task tareaSMS = Task.Run(() => EnviarSMS(request.Nombre, telefono.PhoneNumber.Trim(), InformacionAdicional));
                                    TareasNotificaciones.Add(tareaSMS);
                                });
                            }
                            break;
                    }
                }
                catch (Exception ex)
                {
                    RespuestasFallidas.Add(new Respuesta
                    {
                        Status = 500,
                        Message = $"Message: {ex.Message}, StackTrace: {ex.StackTrace}, Data: {ex.Data}",
                        Data = request
                    });
                    this.Errores++;
                }
            });

            // Esperar la finalización de todas las tareas
            await Task.WhenAll(TareasNotificaciones);

            // Se actualiza la notificacion cuya regla ahora estara modificada con la informacion actual de esta (repeticionActual y ultimaEjecucion)
            Regla regla = !string.IsNullOrWhiteSpace(request.Reglas) ? JsonConvert.DeserializeObject<Regla>(request.Reglas) : new();
            regla.Aplazamiento.RepeticionActual++;
            regla.Aplazamiento.UltimaEjecucion = DateTime.Now;
            // No se modifica el trail ya que podria haber notificaciones que se ejecuten permanentemente y este ir aumentando significativamente
            // Se modifica el campo reglas
            request.Reglas = JsonConvert.SerializeObject(regla);
            // Se actualiza la notificacion
            _ = notificacionBusiness.Actualizar(request);
            if (this.Errores == 0)
            {
                respuesta.Status = 200;
                respuesta.Message = "Todas las alertas a todas las notificaciones se ejecutaron correctamente.";
                respuesta.Data = request;
                respuesta.timeMeasure.Stop();
            }
            else
            {
                // Si no, devuelve en la data un listado de strings con los mensajes indicando cual es el Message, StackTrace y Data de la alerta de notificacion que fallo.
                respuesta.Status = 500;
                respuesta.Message = "Alguna de las alertas falló en su ejecucion";
                respuesta.Data = RespuestasFallidas.Select(respuestaFaliida => respuestaFaliida.Message).ToList();
                respuesta.Function = "ValidarNotificaciones";
                respuesta.timeMeasure.Stop();
            }
            return respuesta;
        }

        /// <summary>
        /// Funcion que crea un registro en la tabla de Alertas
        /// </summary>
        /// <param name="Id"></param>
        /// <param name="Nombre"></param>
        /// <param name="Usuario"></param>
        /// <param name="Trail"></param>
        /// <param name="alertaBusiness"></param>
        /// <returns></returns>
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

        /// <summary>
        /// Funcion para enviar mensajes por SMS
        /// </summary>
        /// <param name="TextoAlerta"></param>
        /// <param name="NumeroTelefonico"></param>
        /// <param name="InformacionExtra"></param>
        /// <exception cref="ArgumentException"></exception>
        private void EnviarSMS(string TextoAlerta, string NumeroTelefonico, string InformacionExtra)
        {
            if (!string.IsNullOrWhiteSpace(NumeroTelefonico))
            {
                if (EsNumeroTelefonicoValido(NumeroTelefonico))
                {
                    if (string.IsNullOrEmpty(AccountSid))
                    {
                        throw new ArgumentException($"'{nameof(AccountSid)}' no puede ser nulo ni estar vacío.", nameof(AccountSid));
                    }

                    if (string.IsNullOrEmpty(AuthToken))
                    {
                        throw new ArgumentException($"'{nameof(AuthToken)}' no puede ser nulo ni estar vacío.", nameof(AuthToken));
                    }
                    try
                    {
                    string numeroSMS = NumeroTelefonico.StartsWith("521") ? $"+{NumeroTelefonico}" : $"+52{NumeroTelefonico}";
                    TwilioClient.Init(AccountSid, AuthToken);
                    MessageResource messageResource = MessageResource.Create(
                        body: $"Por este medio se le notifica que tiene una alerta de '{TextoAlerta}’. Para mayor información ingrese a la plataforma.",
                        from: new Twilio.Types.PhoneNumber($"+{NumeroServicio}"),
                        to: new Twilio.Types.PhoneNumber($"{numeroSMS}")
                    );
                    Console.WriteLine("messageResource: " + JsonConvert.SerializeObject(messageResource));
                    }catch (TwilioException ex)
                    {
                        this.Errores++;
                        Console.WriteLine(ex.Message);
                    }
                }
            }
        }

        /// <summary>
        /// Funcion para enviar mensajes por Whatsapp
        /// </summary>
        /// <param name="TextoAlerta"></param>
        /// <param name="NumeroTelefonico"></param>
        /// <param name="InformacionExtra"></param>
        /// <exception cref="ArgumentException"></exception>
        private void EnviarWhatsapp(string TextoAlerta, string NumeroTelefonico, string InformacionExtra)
        {
            if (!string.IsNullOrWhiteSpace(NumeroTelefonico))
            {
                if (EsNumeroTelefonicoValido(NumeroTelefonico))
                {
                    if (string.IsNullOrEmpty(AccountSid))
                    {
                        throw new ArgumentException($"'{nameof(AccountSid)}' no puede ser nulo ni estar vacío.", nameof(AccountSid));
                    }

                    if (string.IsNullOrEmpty(AuthToken))
                    {
                        throw new ArgumentException($"'{nameof(AuthToken)}' no puede ser nulo ni estar vacío.", nameof(AuthToken));
                    }

                    string numeroWhatsapp = NumeroTelefonico.StartsWith("521") ? $"whatsapp:+{NumeroTelefonico}" : $"whatsapp:+521{NumeroTelefonico}";
                    TwilioClient.Init(AccountSid, AuthToken);
                    CreateMessageOptions messageOptions = new(new PhoneNumber(numeroWhatsapp))
                    {
                        ForceDelivery = true,
                        From = new PhoneNumber($"whatsapp:+{NumeroServicio}"),
                        Body = $"Por este medio se le notifica que tiene una alerta de notificación de **{TextoAlerta}**.\n{InformacionExtra}\nPara mayor información ingrese a la plataforma.",
                        MediaUrl = []
                    };
                    var response = MessageResource.Create(messageOptions);
                    Console.WriteLine("response: " + JsonConvert.SerializeObject(response));
                }
            }
        }

        /// <summary>
        /// Funcion para enviar los correos electronicos
        /// </summary>
        /// <param name="TextoNotificacion"></param>
        /// <param name="CorreoElectronico"></param>
        /// <param name="InformacionExtra"></param>
        private void EnviarCorreoElectronico(string TextoNotificacion, string CorreoElectronico, string InformacionExtra)
        {
            // Verifica si el correo es diferente de una cadena de texto nula o con caracteres de espacio
            if (!string.IsNullOrWhiteSpace(CorreoElectronico))
            {
                // Valida si es un correo electronico valido
                if (EsCorreoValido(CorreoElectronico))
                {
                    // Se crea el cliente para sendGrid
                    SendGridClient client = new(ApiKey);
                    // Se usa el correo destinado para esto
                    EmailAddress from = new(Email, "Grupo FH");
                    string subject = $"Alertamiento de {TextoNotificacion}";
                    EmailAddress to = new(CorreoElectronico);
                    string plainTextContent = "Alertamiento usando servicios de Twilio.";
                    // Ruta del archivo HTML
                    string rutaArchivo = @"..\FHL_SGD_Notificaciones_Api\Shared\AssetEmail.html";

                    // Lee el contenido del archivo HTML y lo almacena en una cadena de texto
                    string contenidoHTML = File.ReadAllText(rutaArchivo);
                    contenidoHTML = contenidoHTML.Replace("{{TextAlert}}" , $"Por este medio se le notifica que tiene una alerta de notificación de '{TextoNotificacion}'. <br /> {InformacionExtra} <br /> Para mayor información ingrese a la plataforma.");
                    SendGridMessage msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, contenidoHTML);
                    // Se envia el email
                    var response = client.SendEmailAsync(msg);
                }
            }
        }

        /// <summary>
        /// Funcion para insertar un registro a la bandeja de usuario
        /// </summary>
        /// <param name="UsuarioId"></param>
        /// <param name="AlertaGuardada"></param>
        /// <param name="Usuario"></param>
        /// <param name="Trail"></param>
        /// <param name="bandejaBusiness"></param>
        private static void EnviarBandeja(long UsuarioId, Alerta AlertaGuardada, string Usuario, string Trail, BandejaBusiness bandejaBusiness)
        {
            Modelo.Entidades.Notificaciones.Bandeja bandeja = new()
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

        /// <summary>
        /// Funcion para enviar notificaciones del tipo push notification usando los servicios de FireBase
        /// </summary>
        /// <param name="Titulo"></param>
        /// <param name="TextoNotificacion"></param>
        private async void EnviarPushNotificacion(string Titulo, string TextoNotificacion)
        {
            try
            {
                // This registration token comes from the client FCM SDKs.
                var registrationToken = FireBaseToken;
                // The topic name can be optionally prefixed with "/topics/".
                var topic = "all";
                // See documentation on defining a message payload.
                var message = new FirebaseAdmin.Messaging.Message()
                {
                    Data = new Dictionary<string, string>()
                        {
                            { "title", Titulo },
                            { "body", TextoNotificacion },
                            { "image", "https://smaller-pictures.appspot.com/images/dreamstime_xxl_65780868_small.jpg" }
                        },
                    Token = registrationToken,
                    Topic = topic
                };

                // Send a message to the device corresponding to the provided
                // registration token.
                if (FirebaseMessaging.DefaultInstance != null)
                {
                    // Response is a message ID string.
                    var response = await FirebaseMessaging.DefaultInstance.SendAsync(message);
                    Console.WriteLine("Successfully sent message: " + response);
                }
                else
                {
                    RespuestasFallidas.Add(new Respuesta
                    {
                        Status = 500,
                        Message = "La aplicacion por default no existe, revise el FireBaseToken o que si este bien implementado en la app movil",
                        Function = "ValidarNotificaciones",
                        Data = $"La aplicacion por default no existe, revise el FireBaseToken o que si este bien implementado en la app movil"
                    });
                    this.Errores++;
                }
            }
            catch (NullReferenceException ex)
            {
                this.Errores++;
                await Console.Out.WriteLineAsync(ex.Message);
            }
        }

        /// <summary>
        /// Funcion para validar si una cadena de texto es un correo electronico valido para el estandar RFC2822
        /// </summary>
        /// <param name="correo"></param>
        /// <returns></returns>
        private static bool EsCorreoValido(string correo)
        {
            // Expresión regular para validar un correo electrónico
            // RFC2822 para validacion de email
            string expresionRegular = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

            // Valida si la cadena coincide con la expresión regular
            Regex regex = new(expresionRegular);
            return regex.IsMatch(correo);
        }

        /// <summary>
        /// Funcion para validar si una cadena de texto es un numero telefonico valido
        /// </summary>
        /// <param name="numeroTelefonico"></param>
        /// <returns></returns>
        private static bool EsNumeroTelefonicoValido(string numeroTelefonico)
        {
            // Expresión regular para validar un numero telefonico valido
            string expresionRegular = @"^\s*(?:\+?(\d{1,3}))?([-. (]*(\d{3})[-. )]*)?((\d{3})[-. ]*(\d{2,4})(?:[-.x ]*(\d+))?)\s*$";

            // Valida si la cadena coincide con la expresión regular
            Regex regex = new(expresionRegular);
            return regex.IsMatch(numeroTelefonico);
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
