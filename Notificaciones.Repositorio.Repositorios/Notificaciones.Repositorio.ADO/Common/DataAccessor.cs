using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Shared.Modelos;
using System.Data;
using System.Reflection;

namespace Notificaciones.Repositorio.ADO.Common
{
    public class DataAccessor : IAccessor
    {
        private static string _connectionString
        {
            get
            {
                var environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

                var builder = new ConfigurationBuilder()
                                .SetBasePath(AppContext.BaseDirectory)
                                .AddJsonFile($"appsettings.json", true, true)
                                .AddJsonFile($"appsettings.{environmentName}.json", true, true)
                                .AddEnvironmentVariables();
                IConfigurationRoot configuration = builder.Build();
                var connectionString = configuration.GetConnectionString("Default");

                return string.IsNullOrWhiteSpace(connectionString) ? string.Empty : connectionString;
            }
        }

        public DataTable SpExecuteTable(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            DataTable table = new DataTable();
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 30;

                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters.ToArray());
                }

                connection.Open();
                var reader = command.ExecuteReader();
                table.Load(reader);
                connection.Close();
            }
            return table;
        }

        public List<T> SpExecuteList<T>(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            List<T> list = new List<T>();
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 30;
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters.ToArray());
                }

                connection.Open();
                var reader = command.ExecuteReader();

                // Mapper
                T obj = default(T);
                var excludedTypes = new List<Type> { typeof(byte[]), typeof(byte) };

                var columns = Enumerable.Range(0, reader.FieldCount).Select(i => reader.GetName(i).ToUpper()).ToArray();
                while (reader.Read())
                {
                    obj = Activator.CreateInstance<T>();
                    foreach (PropertyInfo prop in obj!.GetType().GetProperties())
                    {
                        if (
                            columns.Contains(prop.Name.ToUpper())
                            && !excludedTypes.Contains(reader[prop.Name].GetType())
                            && !object.Equals(reader[prop.Name], DBNull.Value)
                            )
                        {
                            prop.SetValue(obj, reader[prop.Name], null);
                        }
                    }
                    list.Add(obj);
                }
                connection.Close();
            }

            return list;
        }
        public List<Object> SpExecuteList<T>(Object obj, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            List<Object> list = new List<Object>();
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 30;
                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters.ToArray());
                }

                connection.Open();
                var reader = command.ExecuteReader();

                // Mapper
                var excludedTypes = new List<Type> { typeof(byte[]), typeof(byte) };

                var columns = Enumerable.Range(0, reader.FieldCount).Select(i => reader.GetName(i).ToUpper()).ToArray();
                while (reader.Read())
                {
                    foreach (PropertyInfo prop in obj!.GetType().GetProperties())
                    {
                        if (
                            columns.Contains(prop.Name.ToUpper())
                            && !excludedTypes.Contains(reader[prop.Name].GetType())
                            && !object.Equals(reader[prop.Name], DBNull.Value)
                            )
                        {
                            prop.SetValue(obj, reader[prop.Name], null);
                        }
                    }
                    list.Add(obj);
                }
                connection.Close();
            }

            return list;
        }

        /// <summary>
        /// Ejecuta un procedimiento almacenado y devuelve la cadena de respuesta en formato JSON
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="storedProcedureName"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public Respuesta SpSaveJson(out long Id, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            // Se inicializa el Id con 0
            Id = 0;
            // Cadena a devolver
            Respuesta respuesta = new Respuesta();
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 0;

                if (parameters != null)
                {
                    foreach (SqlParameter param in parameters)
                    {
                        command.Parameters.Add(param);
                    }
                }

                // Abre la conexión
                connection.Open();
                // Ejecuta el Procedimiento Almacenado
                SqlDataReader reader = command.ExecuteReader();

                // Obtiene el resultado de las columnas disponibles
                var availableColumns = Enumerable.Range(0, reader.FieldCount)
                    .Select(reader.GetName)
                    .ToList();

                // Obtiene el resultado de la ejecución
                if (reader.Read())
                {
                    respuesta.Data = reader["JsonSalida"].ToString();
                    // Verifica si la columna "TotalRows" existe en el resultado
                    if (availableColumns.Contains("TotalRows"))
                    {
                        try
                        {
                            respuesta.TotalRows = reader["TotalRows"] != DBNull.Value ? (int)reader["TotalRows"] : 0;
                        }
                        catch (Exception ex)
                        {
                            // Maneja la excepción si es necesario
                            throw;
                        }
                    }
                    if (availableColumns.Contains("Id"))
                    {
                        try
                        {
                            Id = reader["Id"] != DBNull.Value ? (long)reader["Id"] : 0;
                        }
                        catch (Exception ex)
                        {
                            // Maneja la excepción si es necesario
                            throw;
                        }
                    }
                }
                // Cierra la conexión y libera recursos de la memoria
                connection.Close();
            }
            // Devuelve la cadena de respuesta
            return respuesta;
        }
        public int SpExecute(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null, IEnumerable<SqlParameter>? outParameters = null)
        {
            var result = 0;
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = System.Data.CommandType.StoredProcedure;

                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters.ToArray());
                }

                if (outParameters != null)
                {
                    foreach (var param in outParameters)
                    {
                        param.Direction = ParameterDirection.Output;
                        command.Parameters.Add(param);
                    }
                }

                connection.Open();
                result = command.ExecuteNonQuery();
                connection.Close();
            }
            return result;
        }

        /// <summary>
        /// Ejecuta un procedimiento almacenado y devuelve la cadena de respuesta en formato JSON
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="storedProcedureName"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public Respuesta ExecuteSp<T>(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            List<T> list = Activator.CreateInstance<List<T>>();
            // Cadena a devolver
            Respuesta respuesta = new Respuesta();
            using (var connection = new SqlConnection(_connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 0;

                if (parameters != null)
                {
                    foreach (SqlParameter param in parameters)
                    {
                        command.Parameters.Add(param);
                    }
                }

                // Abre la conexión
                connection.Open();
                // Ejecuta el Procedimiento Almacenado
                SqlDataReader reader = command.ExecuteReader();

                // Obtiene el resultado de las columnas disponibles
                var availableColumns = Enumerable.Range(0, reader.FieldCount)
                    .Select(reader.GetName)
                    .ToList();

                // Obtiene el resultado de la ejecución
                if (reader.Read())
                {
                    // Mapea las columnas a las propiedades de T
                    var properties = typeof(T).GetProperties().ToDictionary(p => p.Name, StringComparer.OrdinalIgnoreCase);

                    while (reader.Read())
                    {
                        // Crea una instancia de T
                        T instance = Activator.CreateInstance<T>();

                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            // Obtiene el nombre de la columna
                            string columnName = reader.GetName(i);

                            // Verifica si la propiedad existe en T
                            if (properties.TryGetValue(columnName, out var propertyInfo))
                            {
                                // Asigna el valor de la columna a la propiedad correspondiente en T
                                propertyInfo.SetValue(instance, reader[i] == DBNull.Value ? null : reader[i]);
                            }
                        }

                        // Agrega la instancia a la lista
                        list.Add(instance);
                    }

                    if (reader.NextResult())
                    {
                        if (reader.Read() && reader.FieldCount > 0)
                        {
                            respuesta.Data = reader[0].ToString();
                        }
                    }
                    // Verifica si la columna "TotalRows" existe en el resultado
                    if (availableColumns.Contains("TotalRows"))
                    {
                        try
                        {
                            respuesta.TotalRows = reader["TotalRows"] != DBNull.Value ? (int)reader["TotalRows"] : 0;
                        }
                        catch (Exception ex)
                        {
                            // Maneja la excepción si es necesario
                            throw;
                        }
                    }
                }

                // Cierra la conexión y libera recursos de la memoria
                connection.Close();
            }
            // Devuelve la cadena de respuesta
            return respuesta;
        }
        public List<T> MapTable<T>(DataTable dataTable)
        {
            List<T> list = new List<T>();
            T obj = default(T);
            var excludedTypes = new List<Type> { typeof(byte[]), typeof(byte) };
            foreach (DataRow dr in dataTable.Rows)
            {
                obj = Activator.CreateInstance<T>();
                foreach (PropertyInfo prop in obj!.GetType().GetProperties())
                {
                    if (dataTable.Columns.Contains(prop.Name)
                        && !object.Equals(dr[prop.Name], DBNull.Value)
                        && !excludedTypes.Contains(dr[prop.Name].GetType()))
                    {
                        prop.SetValue(obj, dr[prop.Name], null);
                    }
                }
                list.Add(obj);
            }
            return list;
        }

        public T MapRow<T>(DataRow dr)
        {
            T obj = default(T);
            obj = Activator.CreateInstance<T>();
            var excludedTypes = new List<Type> { typeof(byte[]), typeof(byte) };
            foreach (PropertyInfo prop in obj!.GetType().GetProperties())
            {
                if (FindColumn(prop.Name, dr)
                    && !object.Equals(dr[prop.Name], DBNull.Value)
                    && !excludedTypes.Contains(dr[prop.Name].GetType()))
                {
                    prop.SetValue(obj, dr[prop.Name], null);
                }
            }
            return obj;
        }

        public bool FindColumn(string columnName, DataRow row)
        {
            try
            {
                return row[columnName] != null;
            }
            catch
            {
                return false;
            }
        }

        public Respuesta SpExcuteJson(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            throw new NotImplementedException();
        }

        public Respuesta SpExcuteValidacion(out List<ListaContacto> ObjectArray, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            throw new NotImplementedException();
        }
    }
}
