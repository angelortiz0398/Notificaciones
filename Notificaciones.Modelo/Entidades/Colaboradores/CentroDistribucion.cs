using Notificaciones.Modelo.Entidades.Generales;

namespace Notificaciones.Modelo.Entidades.Colaboradores
{
    public class CentroDistribucion : EntidadBase
    {
        public string? Nombre { get; set; }

        public string? Descripcion { get; set; }

        public string? Geolocalizacion { get; set; }

        public string? Usuario { get; set; }
    }
}
