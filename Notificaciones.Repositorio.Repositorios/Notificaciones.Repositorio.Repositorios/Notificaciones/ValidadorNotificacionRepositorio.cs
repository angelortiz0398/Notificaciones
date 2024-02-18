using Notificaciones.Repositorio.ADO;
using Notificaciones.Repositorio.ADO.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System;

namespace Notificaciones.Repositorio.Repositorios.Notificaciones
{
    public class ValidadorNotificacionRepositorio : IValidadorNotificacionRepositorio
    {
        public bool ValidarAlertamientoNotificacion(long notificacionId)
        {
            bool resultado;
            try
            {
                MethodsDB methodsDB = new MethodsDB();
                var respuestaSP = new BaseData().accesor.SpExcuteJson(methodsDB.QueryObtenerValidacionNotificacionArreglo[notificacionId - 1]);
                resultado = Convert.ToBoolean(respuestaSP.Data);
            }
            catch (Exception)
            {
                throw;
            }
            return resultado;
        }
    }
}
