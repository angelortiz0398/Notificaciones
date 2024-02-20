using Newtonsoft.Json;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class Email
    {
        [JsonProperty("email")]
        public string EmailAddress { get; set; }
    }
}
