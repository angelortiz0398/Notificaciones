using System;
using System.Net.Http;
using System.ServiceProcess;
using System.Threading.Tasks;

namespace NotificacionesService
{
    public partial class NotificacionService : ServiceBase
    {
        public NotificacionService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            EnviaSolicitud();
        }

        protected override void OnStop()
        {
        }

        public async Task EnviaSolicitud()
        {
            // URL del webhook
            string url = "https://webhook.site/5192ace6-5d57-4554-b0e5-9de83cbd4601";

            // Crear una instancia de HttpClient
            using (HttpClient client = new HttpClient())
            {
                try
                {
                    while (true)
                    {
                        // Realizar la solicitud GET
                        HttpResponseMessage response = await client.GetAsync(url);

                        // Verificar si la solicitud fue exitosa
                        if (response.IsSuccessStatusCode)
                        {
                            // Leer y mostrar la respuesta
                            string responseBody = await response.Content.ReadAsStringAsync();
                            Console.WriteLine("Respuesta del servidor:");
                            Console.WriteLine(responseBody);
                        }
                        else
                        {
                            Console.WriteLine($"Error al hacer la solicitud: {response.StatusCode}");
                        }

                        // Esperar 30 segundos antes de la próxima solicitud
                        await Task.Delay(TimeSpan.FromSeconds(30));
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Ocurrió un error: {ex.Message}");
                }
            }
        }
    }
}
