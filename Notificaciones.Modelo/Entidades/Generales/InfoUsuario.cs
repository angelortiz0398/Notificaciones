using System;
using System.Collections.Generic;

namespace Notificaciones.Modelo.Entidades.Generales
{
    public class InfoUsuario
    {
        public long UsuarioId { get; set; }

        public long EmpleadoId { get; set; }

        public long? FotoPerfilId { get; set; }

        public string NombreUsuario { get; set; }

        public string NumeroEmpleado { get; set; }

        public string Nombre { get; set; }

        public string CorreoElectronico { get; set; }

        public string TelefonoMovil { get; set; }

        public DateTime FechaNacimiento { get; set; }

        public List<UsuarioCliente> UsuarioClientes { get; set; }
    }
}
