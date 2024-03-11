using Microsoft.AspNetCore.Mvc;
using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Negocio.Negocios.Notificaciones;

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
        /// <remarks>
        ///     <p>Ejemplo de Fecha con hora: 2024-03-11T12:00:00.000</p>
        ///     <p>La fecha se obtiene del servicio de Windows que la toma del sistema operativo </p>
        ///</remarks>
        /// <param name="FechaHoraValidacion"></param>
        /// <returns>Retorna una Respuesta, dependiendo si fue exitosa tendra estatus 200 (Exitoso) o 500 (Error del servidor, tanto de la base de datos o de Twilio) </returns>
        /// <response code="200">Retorna que se ha ejecutado correctamente el proceso o que no había ninguna notificación activada qué alertar.</response>
        /// <response code="400">Retorna un error ya que no se han enviado los contactos necesarios para enviar la notificación por los medios solicitados.</response>
        /// <response code="500">Retorna un error ya que ha ocurrido al tratar de construir la llamada a los diferentes SP validadores o al momento de la ejecución. 
        /// También ocurre por problemas con la API de Twilio para envío de emails, whatsapp, sms o Firebase.</response>
        [HttpGet("Validar/{FechaHoraValidacion}")]
        [ProducesResponseType(typeof(Respuesta), 200)]
        [ProducesResponseType(typeof(Respuesta), 400)]
        [ProducesResponseType(typeof(Respuesta), 500)]
        [Produces("application/json")]
        [FormatFilter]
        public Respuesta ValidarNotificaciones(DateTime FechaHoraValidacion)
        {
            return _bss.ValidarNotificaciones(FechaHoraValidacion);
        }
    }
}
