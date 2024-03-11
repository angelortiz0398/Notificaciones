using Microsoft.Data.SqlClient;
using Notificaciones.Modelo.Entidades.Generales;
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
        public bool ValidarAlertamientoNotificacion(out List<ListaContacto> objectArray, out string InformacionAdicional, long notificacionId, TimeSpan Intervalo)
        {
            objectArray = [];
            bool resultado;
            MethodsDB methodsDB = new();
            SqlParameter comandoIntervalo = new()
            {
                ParameterName = "@Intervalo",
                DbType = System.Data.DbType.Time,
                Value = Intervalo
            };
            try
            {
                IEnumerable<SqlParameter> parameters = new List<SqlParameter>([comandoIntervalo]);
                Respuesta respuestaSP = new BaseData().accesor.SpExcuteValidacion(out List<ListaContacto> ObjectArray, methodsDB.QueryObtenerValidacionNotificacionArreglo[notificacionId - 1], parameters);
                objectArray = ObjectArray;
                InformacionAdicional = respuestaSP.Message;
                resultado = Convert.ToBoolean(respuestaSP.Data);
            }
            catch (Exception ex)
            {
                InformacionAdicional = ex.Message;
                throw;
            }
            return resultado;
        }
    }
}
