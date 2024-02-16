using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class BandejaBusiness : GenericBusiness<Bandeja>, IBandejaBusiness
    {
        private readonly IBandejaRepositorio _repo;

        public BandejaBusiness(IGenericRepository<Bandeja> iGenericRepository, IBandejaRepositorio repo) : base()
        {
            _repo = repo;
        }
    }
}
