using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System.Collections.Generic;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class BandejaBusiness : GenericBusiness<Bandeja>, IBandejaBusiness
    {
        private readonly IBandejaRepositorio _repo;

        public BandejaBusiness(IGenericRepository<Bandeja> iGenericRepository, IBandejaRepositorio repo) : base()
        {
            _repo = repo;
        }
        public List<Bandeja> ObtenerTodos()
        {
            return _repo.GetAll();
        }

        public Bandeja Insertar(Bandeja notificacion)
        {
            notificacion.Id = _repo.Create(notificacion);
            return notificacion;
        }

        public Bandeja Actualizar(Bandeja notificacion)
        {
            notificacion.Id = _repo.Update(notificacion);
            return notificacion;
        }
    }
}
