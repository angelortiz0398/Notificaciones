using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class CategoriaNotificacionBusiness : GenericBusiness<CategoriaNotificacion>, ICategoriaNotificacionBusiness
    {
        private readonly ICategoriaNotificacionRepositorio _repo;

        public CategoriaNotificacionBusiness(IGenericRepository<CategoriaNotificacion> iGenericRepository, ICategoriaNotificacionRepositorio repo) : base()
        {
            _repo = repo;
        }
    }
}
