using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using System.Collections.Generic;
using System.Data;
using System;
using Microsoft.Data.SqlClient;

namespace Notificaciones.Repositorio.Contratos.Notificaciones
{
    public interface IBandejaRepositorio : IGenericRepository<Bandeja>
    {
    }
}
