﻿using Microsoft.Data.SqlClient;
using Shared.Modelos;
using System.Data;

namespace Notificaciones.Repositorio.ADO.Common
{
    public interface IAccessor
    {
        Respuesta SpExcuteJson(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null);
        Respuesta SpSaveJson(out long Id, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null);
        Respuesta ExecuteSp<T>(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null);
        DataTable SpExecuteTable(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null);
        List<Object> SpExecuteList<T>(Object obj, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null);
        int SpExecute(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null, IEnumerable<SqlParameter>? outParameters = null);
        List<T> MapTable<T>(DataTable dataTable);
        T MapRow<T>(DataRow dr);
        bool FindColumn(string columnName, DataRow row);
    }
}