using Newtonsoft.Json;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class User
    {
        [JsonProperty("userId")]
        public int UserId { get; set; }
    }
}
