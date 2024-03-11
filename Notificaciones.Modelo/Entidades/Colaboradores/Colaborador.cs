using Notificaciones.Modelo.Entidades.Generales;
using System;

namespace Notificaciones.Modelo.Entidades.Colaboradores
{
    public class Colaborador : EntidadBase
    {
        public string? Nombre { get; set; }

        public string? Rfc { get; set; }

        public string Identificacion { get; set; }

        public long? TipoPerfilesId { get; set; }

        public long? CentroDistribucionesId { get; set; }

        public string? Nss { get; set; }

        public string? CorreoElectronico { get; set; }

        public string? Telefono { get; set; }

        public string? Imei { get; set; }

        public string? Habilidades { get; set; }

        public string? TipoVehiculo { get; set; }

        public bool Estado { get; set; }

        public string? Comentarios { get; set; }

        public DateTime? UltimoAcceso { get; set; }

        public string? Usuario { get; set; }

        public TipoPerfil? TipoPerfiles { get; set; }

        public CentroDistribucion? CentroDistribuciones { get; set; }
    }
}
