using Shared.Modelos;
using System;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class Alerta : EntidadBase
    {
        public DateTime FechaCreacionAlerta { get; set; }

        public long NotificacionesId { get; set; }

        public string? TextoAlerta { get; set; }

        public string? Usuario { get; set; }

        public long? Notificaciones { get; set; }
    }
}
