using Notificaciones.Modelo.Entidades.Generales;

namespace Notificaciones.Modelo.Entidades.Notificaciones
{
    public class Notificacion : EntidadBase
    {
        public string? Nombre { get; set; }

        public bool? Activada { get; set; }

        public string? Condiciones { get; set; }

        public string? Reglas { get; set; }

        public string? ListaContactos { get; set; }

        public long? NotificarPorId { get; set; }

        public long CategoriasNotificacionesId { get; set; }

        public string? Usuario { get; set; }

        public CategoriaNotificacion? CategoriasNotificaciones { get; set; }
    }
}
