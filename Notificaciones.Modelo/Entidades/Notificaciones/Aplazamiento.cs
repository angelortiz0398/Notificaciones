using System;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class Aplazamiento
    {
        public TimeSpan? Intervalo { get; set; } = new TimeSpan(23, 59, 59);
        public int? Repeticiones { get; set; } = 1; // Valor por defecto
        public int RepeticionActual { get; set; } = 0; 
        public DateTime UltimaEjecucion { get; set; } = DateTime.Now;
    }
}
