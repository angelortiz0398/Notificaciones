using AdministracionSGD.Services.Api.Controllers.Common;
using Microsoft.AspNetCore.Mvc;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Negocios.Notificaciones;
using Shared.Modelos;

namespace FHL_SGD_Notificaciones_Api.Controllers
{
    /// <summary>
    /// Controlador para la manipulacion de notificaciones atraves de Twilio
    /// </summary>
    [ApiController]
    [Route("[controller]")]
    public class EnvioNotificacionController : Controller
    {
        private EnvioViajeBusiness _bss { get; set; } = new();
        /// <summary>
        /// Crea una notificacion usando Twilio por los medios que se le especifican por la request.
        /// Ademas, crea un registro en la tabla historica de alertas 
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost("CreacionNotificacion")]
        public Respuesta CreacionNotificacion(Notificacion request)
        {
            return _bss.CreacionNotificacion(request);
        }
    }
}
