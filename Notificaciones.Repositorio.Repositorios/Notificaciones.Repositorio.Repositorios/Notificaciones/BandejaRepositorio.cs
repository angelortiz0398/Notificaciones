using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Repositorio.ADO.Common;
using Notificaciones.Repositorio.ADO;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Shared.Modelos;
using System;
using System.Collections.Generic;

namespace Notificaciones.Repositorio.Repositorios.Notificaciones
{
    public class BandejaRepositorio : IBandejaRepositorio
    {
        public BandejaRepositorio()
        {
        }

        public long Create(Bandeja item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Bandeja> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarBandejas, parameters);
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

        public long Delete(Bandeja item)
        {
            throw new System.NotImplementedException();
        }

        public List<Bandeja> GetAll()
        {
            List<Bandeja> lista = [];
            var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryObtenerBandejaPaginado);
            lista = JsonConvert.DeserializeObject<List<Bandeja>>((string)respuestaSP.Data) ?? [];
            return lista;
        }

        public Bandeja GetId(long nId)
        {
            throw new System.NotImplementedException();
        }

        public long Update(Bandeja item)
        {
            // Objeto a devolver al generar la consulta
            Respuesta respuesta = new Respuesta("GuardarRegistro");

            try
            {
                SqlParameter comandoLista = new SqlParameter();

                List<Bandeja> lista = new() { item };
                string listaJson = JsonConvert.SerializeObject(lista);
                comandoLista.ParameterName = "@Lista";
                comandoLista.DbType = System.Data.DbType.String;
                comandoLista.Value = listaJson;


                IEnumerable<SqlParameter> parameters = new List<SqlParameter>(new List<SqlParameter> { comandoLista });


                var respuestaSP = new BaseData().accesor.SpExcuteJson(MethodsDB.QueryInsertarActualizarBandejas, parameters);
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
