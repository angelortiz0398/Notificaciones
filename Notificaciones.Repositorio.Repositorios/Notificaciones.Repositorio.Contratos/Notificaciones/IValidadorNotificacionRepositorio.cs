using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.Contratos.Notificaciones
{
    public interface IValidadorNotificacionRepositorio
    {
        public bool ValidarAlertamientoNotificacion(long notificacionId);
    }
}
