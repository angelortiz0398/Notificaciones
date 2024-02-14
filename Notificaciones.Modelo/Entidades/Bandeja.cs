using Notificaciones.Modelo.Generales;
using System;

namespace Notificaciones.Modelo.Entidades
{
    public class Bandeja : EntidadBase
    {
        public long ColaboradoresId { get; set; }

        public long AlertasId { get; set; }

        public DateTime FechaLlegada { get; set; }

        public DateTime FechaCreacionAlerta { get; set; }

        public bool Lectura { get; set; }

        public string Usuario { get; set; }

        public Alerta? Alertas { get; set; }
    }
}
