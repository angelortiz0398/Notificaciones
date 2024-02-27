using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Repositorio.ADO;
using Notificaciones.Repositorio.ADO.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System;
using System.Collections.Generic;

namespace Notificaciones.Repositorio.Repositorios.Notificaciones
{
    public class ValidadorNotificacionRepositorio : IValidadorNotificacionRepositorio
    {
        public bool ValidarAlertamientoNotificacion(out List<ListaContacto> objectArray,long notificacionId)
        {
            objectArray = [];
            bool resultado;
            try
            {
                MethodsDB methodsDB = new MethodsDB();
                var respuestaSP = new BaseData().accesor.SpExcuteValidacion(out List<ListaContacto> ObjectArray, methodsDB.QueryObtenerValidacionNotificacionArreglo[notificacionId - 1]);
                objectArray = ObjectArray;
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
