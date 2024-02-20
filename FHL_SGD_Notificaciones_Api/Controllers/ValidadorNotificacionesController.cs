using Microsoft.AspNetCore.Mvc;
using Notificaciones.Negocio.Negocios.Notificaciones;
using Shared.Modelos;

namespace FHL_SGD_Notificaciones_Api.Controllers
{
    /// <summary>
    /// Controlador para la validacion de notificaciones y envio de estas 
    /// </summary>
    [ApiController]
    [Route("[controller]")]
    public class ValidadorNotificacionesController : Controller
    {
        private ValidadorNotificacionesBusiness _bss { get; set; } = new();

        /// <summary>
        /// Metodo para validar si existen notificaciones activadas y si hay alguna que se deba alertar
        /// </summary>
        /// <param name="FechaHoraValidacion"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso) o 500 (Error del servidor, tanto de la base de datos o de Twilio) </returns>
        [HttpGet("Validar/{FechaHoraValidacion}")]
        public Respuesta ValidarNotificaciones(DateTime FechaHoraValidacion)
        {
            return _bss.ValidarNotificaciones(FechaHoraValidacion);
        }
    }
}
