using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Repositorio.ADO;
using Notificaciones.Repositorio.ADO.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System;
using System.Collections.Generic;

namespace Notificaciones.Repositorio.Repositorios.Notificaciones
{
    public class NotificacionRepositorio : INotificacionRepositorio
    {
        public NotificacionRepositorio()
        {
        }

        public long Create(Notificacion item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Notificacion> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarNotificaciones, parameters);
                if (respuestaSP != null)
                {
                    respuesta.Data = item;
                    respuesta.TotalRows = respuestaSP.TotalRows;
                    respuesta.Message = respuestaSP.Data.ToString();
                    respuesta.PageIndex = null;
                    respuesta.PageSize = null;
                    respuesta.Status = 200;
                    respuesta.Function = "GuardarRegistro";
                    respuesta.timeMeasure.Stop();
                }
                else
                {
                    respuesta.Status = 400;
                    respuesta.Message = "Ha ocurrido un error en la ejecución del SP";
                    respuesta.timeMeasure.Stop();
                }
            }
            catch (Exception e)
            {
                respuesta.Status = 500;
                respuesta.Message = e.Message.ToString();
                throw;
            }
            return item.Id;
        }

        public long Delete(Notificacion item)
        {
            throw new System.NotImplementedException();
        }

        public List<Notificacion> GetAll()
        {
            List<Notificacion> lista = [];

            var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryObtenerNotificacionesPaginado);
            lista = JsonConvert.DeserializeObject<List<Notificacion>>((string)respuestaSP.Data) ?? [];
            return lista;
        }

        public Notificacion GetId(long nId)
        {
            throw new System.NotImplementedException();
        }

        public long Update(Notificacion item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Notificacion> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarNotificaciones, parameters);
                if (respuestaSP != null)
                {
                    respuesta.Data = item;
                    respuesta.TotalRows = respuestaSP.TotalRows;
                    respuesta.Message = respuestaSP.Data.ToString();
                    respuesta.PageIndex = null;
                    respuesta.PageSize = null;
                    respuesta.Status = 200;
                    respuesta.Function = "GuardarRegistro";
                    respuesta.timeMeasure.Stop();
                }
                else
                {
                    respuesta.Status = 400;
                    respuesta.Message = "Ha ocurrido un error en la ejecución del SP";
                    respuesta.timeMeasure.Stop();
                }
            }
            catch (Exception e)
            {
                respuesta.Status = 500;
                respuesta.Message = e.Message.ToString();
                throw;
            }
            return item.Id;
        }
    }
}
