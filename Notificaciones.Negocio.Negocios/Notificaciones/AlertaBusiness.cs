using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System.Collections.Generic;

namespace Notificaciones.Negocio.Negocios.Notificaciones
{
    public class AlertaBusiness : GenericBusiness<Alerta>, IAlertaBusiness
    {
        private readonly IAlertaRepositorio _repo;

        public AlertaBusiness(IGenericRepository<Alerta> iGenericRepository, IAlertaRepositorio repo) : base()
        {
            _repo = repo;
        }

        public List<Alerta> ObtenerTodos()
        {
            return _repo.GetAll();
        }

        public Alerta Insertar(Alerta alerta)
        {
            alerta.Id = _repo.Create(alerta);
            return alerta;
        }
    }
}
