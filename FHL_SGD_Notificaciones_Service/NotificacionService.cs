using FHL_SGD_Notificaciones_Service.Properties;
using FHL_SGD_Notificaciones_Service.Shared;
using Newtonsoft.Json;
using System;
using System.Configuration;
using System.Diagnostics;
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
        private string UrlServer { get; set; } = string.Empty;
        private string ExecutionTime { get; set; } = string.Empty;
        private readonly string Environment = string.Empty; 


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
            Environment = Properties.Settings.Default.ASPNETCORE_ENVIRONMENT;
            UrlServer = ConfigurationManager.AppSettings[$"{Environment}.UrlServer"];
            ExecutionTime = ConfigurationManager.AppSettings[$"{Environment}.ExecutionTime"];

        }

        protected override void OnStart(string[] args)
        {
            EventLog1.WriteEntry("Se inicio correctamente el proceso.");
            _ = EnviaSolicitud();
        }

        protected override void OnStop()
        {
            EventLog1.WriteEntry("Se detuvo correctamente el proceso.");
        }

        public async Task EnviaSolicitud()
        {
            string url = $"{UrlServer}/ValidadorNotificaciones/Validar";
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
                        // Guardar la respuesta y verificar si el estatus de la respuesta fue diferente de 200 (Ok)
                        string responseBody = await response.Content.ReadAsStringAsync();
                        RespuestaNotificacion respuesta = JsonConvert.DeserializeObject<RespuestaNotificacion>(responseBody);
                        EventLog1.WriteEntry($"Respuesta: {responseBody}");
                        if (respuesta.Status != 200)
                        {
                            EventLog1.WriteEntry($"Consulta a {urlBase} fallida. Respuesta: {responseBody}");
                        }

                        // Espera algunos segundos antes de la próxima solicitud
                        await Task.Delay(TimeSpan.FromSeconds(Convert.ToInt32(ExecutionTime)));
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
