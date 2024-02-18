using System;
using System.Diagnostics;
using System.Net;
using System.Net.Http;
using System.ServiceProcess;
using System.Threading.Tasks;

namespace NotificacionesService
{
    public partial class NotificacionService : ServiceBase
    {
        private EventLog EventLog1 { get; set; }
        private readonly string logSourceName = "NotificacionSource";
        private readonly string logName = "Log";

        public NotificacionService()
        {
            InitializeComponent();
            this.AutoLog = false;
            EventLog1 = new EventLog();

            if (!EventLog.SourceExists(logSourceName))
            {
                EventLog.CreateEventSource(logSourceName, logName);
            }

            EventLog1.Source = logSourceName;
            EventLog1.Log = logName;
        }

        protected override void OnStart(string[] args)
        {
            EventLog1.WriteEntry("Se inicio correctamente el proceso.");
            EnviaSolicitud();
        }

        protected override void OnStop()
        {
        }

        public async Task EnviaSolicitud()
        {
            string url = "https://localhost:7289/ValidadorNotificaciones/Validar";
            // Ignorar la validación del certificado
            HttpClientHandler handler = new HttpClientHandler();
            handler.ServerCertificateCustomValidationCallback = (sender, cert, chain, sslPolicyErrors) => true;

            // Crear una instancia de HttpClient
            using (HttpClient client = new HttpClient(handler))
            {
                try
                {
                    while (true)
                    {
                        var urlBase = url + "/" + DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff");
                        // Realizar la solicitud GET
                        HttpResponseMessage response = await client.GetAsync(urlBase);
                        // Verificar si la solicitud fue exitosa
                        if (response.StatusCode == HttpStatusCode.OK)
                        {
                            // Leer y mostrar la respuesta
                            string responseBody = await response.Content.ReadAsStringAsync();
                        }
                        else
                        {
                            EventLog1.WriteEntry($"Consulta a {urlBase} fallida.");
                        }

                        // Esperar 30 segundos antes de la próxima solicitud
                        await Task.Delay(TimeSpan.FromSeconds(30));
                    }
                }
                catch (Exception ex)
                {
                    EventLog1.WriteEntry($"Ocurrió un error: {ex.Message}, data: {ex.Data}, InnerException: {ex.InnerException}", EventLogEntryType.Error);
                }
            }
        }
    }
}
