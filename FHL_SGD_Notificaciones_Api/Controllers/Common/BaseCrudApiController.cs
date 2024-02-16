using Notificaciones.Negocio.Negocios.Common;
using Shared.Modelos;

namespace AdministracionSGD.Services.Api.Controllers.Common
{
    public abstract class BaseCrudApiController<T1, T2> : BaseApiController where T1 : EntidadBase where T2 : GenericBusiness<T1>
    {
        internal T2 _bss;

        public BaseCrudApiController()
        {
            _bss = Activator.CreateInstance<T2>();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="request"></param>
        /// <exception cref="ApplicationException"></exception>
        private void ValidaTrail(T1 request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Trail))
                throw new ApplicationException("El Trail del objeto está vacio");
        }

        /// <summary>
        /// 
        /// </summary>
        private void InjectAuthorization()
        {
            _bss.AddAuthorization(Authorization);
        }
    }
}