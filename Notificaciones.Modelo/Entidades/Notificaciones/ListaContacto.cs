using Newtonsoft.Json;
using System.Collections.Generic;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class ListaContacto
    {
        [JsonProperty("emails")]
        public List<Email> Emails { get; set; }

        [JsonProperty("phones")]
        public List<Phone> Phones { get; set; }

        [JsonProperty("users")]
        public List<User> Users { get; set; }
    }
}
