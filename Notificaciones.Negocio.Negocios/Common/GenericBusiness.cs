using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Negocio.Common;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Repositorios.Common;
using System;
using System.Collections.Generic;
using System.Net.Http.Headers;

namespace Notificaciones.Negocio.Negocios.Common
{
    public class GenericBusiness<T1> : IGenericBusiness<T1>, IDisposable where T1 : class, IEntidadBase
    {
        protected readonly IGenericRepository<T1> _iGenericRepository;

        protected Trail _trail = new();

        protected AuthenticationHeaderValue _authorization;

        public GenericBusiness()
        {
            _iGenericRepository = new GenericRepository<T1>();
            _authorization = null;
        }

        public virtual long Create(T1 item)
        {
            return _iGenericRepository.Create(item);
        }

        public virtual long Delete(T1 item)
        {
            return _iGenericRepository.Delete(item);
        }

        public virtual IEnumerable<T1> GetAll()
        {
            return _iGenericRepository.GetAll();
        }

        public virtual T1 GetId(long nId)
        {
            return _iGenericRepository.GetId(nId);
        }

        public virtual long Update(T1 item)
        {
            return _iGenericRepository.Update(item);
        }

        public void AddAuthorization(AuthenticationHeaderValue authorization)
        {
            _authorization = authorization;
        }

        public void Dispose()
        {
        }
    }
}
