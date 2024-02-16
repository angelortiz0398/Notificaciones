using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class NotificacionBusiness : GenericBusiness<Notificacion>, INotificacionBusiness
    {
        private readonly INotificacionRepositorio _repo;

        public NotificacionBusiness(IGenericRepository<Notificacion> iGenericRepository, INotificacionRepositorio repo) : base()
        {
            _repo = repo;
        }
    }
}
