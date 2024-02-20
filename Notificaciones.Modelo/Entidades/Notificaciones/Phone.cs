using Newtonsoft.Json;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class Phone
    {
        [JsonProperty("phone")]
        public string PhoneNumber { get; set; }
    }
}
