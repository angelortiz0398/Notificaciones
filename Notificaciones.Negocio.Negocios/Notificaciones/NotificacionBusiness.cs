using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System.Collections.Generic;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class NotificacionBusiness : GenericBusiness<Notificacion>, INotificacionBusiness
    {
        private readonly INotificacionRepositorio _repo;

        public NotificacionBusiness(IGenericRepository<Notificacion> iGenericRepository, INotificacionRepositorio repo) : base()
        {
            _repo = repo;
        }

        public List<Notificacion> ObtenerTodos()
        {
            return _repo.GetAll();
        }

        public Notificacion  Insertar(Notificacion notificacion)
        {
            notificacion.Id = _repo.Create(notificacion);
            return notificacion;
        }

        public Notificacion Actualizar(Notificacion notificacion)
        {
            notificacion.Id = _repo.Update(notificacion);
            return notificacion;
        }
    }
}
