using System;

namespace Notificaciones.Modelo.Generales
{
    public interface IEntidadBase
    {
        long Id { get; set; }

        string Trail { get; set; }

        bool Eliminado { get; set; }

        DateTime FechaCreacion { get; set; }

        bool EsNuevo { get; }
    }
}
