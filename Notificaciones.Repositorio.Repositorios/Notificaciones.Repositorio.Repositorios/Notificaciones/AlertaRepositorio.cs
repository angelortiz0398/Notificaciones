using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Generales;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Repositorio.ADO;
using Notificaciones.Repositorio.ADO.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Notificaciones.Repositorio.Repositorios.Notificaciones
{
    public class AlertaRepositorio : IAlertaRepositorio
    {
        public AlertaRepositorio()
        {
        }

        public long Create(Alerta item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Alerta> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarAlertas, parameters);
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

        public long Delete(Alerta item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("EliminarRegistro");

            try
            {
                SqlParameter comandoId = new SqlParameter();


                comandoId.ParameterName = "@Id";
                comandoId.DbType = System.Data.DbType.Int64;
                comandoId.Value = item.Id;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoId });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryEliminarAlertas, parameters);
                if (respuestaSP != null)
                {
                    respuesta.Data = new Alerta();
                    respuesta.TotalRows = respuestaSP.TotalRows;
                    respuesta.Message = respuestaSP.Data.ToString();
                    respuesta.PageIndex = null;
                    respuesta.PageSize = null;
                    respuesta.Status = 200;
                    respuesta.Function = "EliminarRegistro";
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

        public List<Alerta> GetAll()
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("ObtenerRegistros");
            List<Alerta> lista = new List<Alerta>();
            try
            {
                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryObtenerAlertasPaginado);
                if (respuestaSP != null)
                {
                    lista = JsonConvert.DeserializeObject<List<Alerta>>((string)respuestaSP.Data) ?? new();
                    //respuesta.Data = JsonConvert.DeserializeObject<List<Alerta>>(respuestaSP.Data.ToString());
                    respuesta.Status = 200;
                    respuesta.Function = "ObtenerRegistros";
                    respuesta.timeMeasure.Stop();
                }
                else
                {
                    respuesta.Status = 400;
                    respuesta.Message = "Ha ocurrido un error en la ejecución del SP";
                }
            }
            catch (Exception e)
            {
                respuesta.Status = 500;
                respuesta.Message = e.Message.ToString();
                throw;
            }
            return lista;
        }

        public Alerta GetId(long nId)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("ObtenerRegistros");
            List<Alerta> lista = new List<Alerta>();
            try
            {
                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryObtenerAlertasPaginado);
                if (respuestaSP != null)
                {
                    lista = JsonConvert.DeserializeObject<List<Alerta>>((string)respuestaSP.Data) ?? new();
                    //respuesta.Data = JsonConvert.DeserializeObject<List<Alerta>>(respuestaSP.Data.ToString());
                    respuesta.Status = 200;
                    respuesta.Function = "ObtenerRegistros";
                    respuesta.timeMeasure.Stop();
                }
                else
                {
                    respuesta.Status = 400;
                    respuesta.Message = "Ha ocurrido un error en la ejecución del SP";
                }
            }
            catch (Exception e)
            {
                respuesta.Status = 500;
                respuesta.Message = e.Message.ToString();
                throw;
            }
            return lista.First();
        }

        public long Update(Alerta item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Alerta> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarAlertas, parameters);
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
