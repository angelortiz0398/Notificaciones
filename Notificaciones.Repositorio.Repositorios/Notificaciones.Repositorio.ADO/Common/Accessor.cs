using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Shared.Modelos;
using System.Data;
using System.Reflection;

using SqlConnection = Microsoft.Data.SqlClient.SqlConnection;

namespace Notificaciones.Repositorio.ADO.Common
{
    public class Accessor : IAccessor, IDisposable
    {
        private readonly string connectionString;

        public Accessor(string connectionStringName)
        {
            this.connectionString = GetConnectionString(connectionStringName);
        }

        public DataTable SpExecuteTable(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            DataTable table = new DataTable();
            using (var connection = new SqlConnection(connectionString))
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

        public List<Object> SpExecuteList<T>(Object obj2, string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            List<Object> list = new();
            using (var connection = new SqlConnection(connectionString))
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
                    Object obj = Activator.CreateInstance(obj2.GetType());
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
        public Respuesta SpExcuteJson(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            // Cadena a devolver
            Respuesta respuesta = new Respuesta();
            using (var connection = new SqlConnection(connectionString))
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
                }

                // Cierra la conexión y libera recursos de la memoria
                connection.Close();
            }
            // Devuelve la cadena de respuesta
            return respuesta;
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
            using (var connection = new SqlConnection(connectionString))
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

        /// <summary>
        /// Ejecuta un procedimiento almacenado y devuelve los registos y la cantidad de registros
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="storedProcedureName"></param>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public Respuesta ExecuteSp<T>(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null)
        {
            List<T> list = Activator.CreateInstance<List<T>>();
            bool tieneBusquedaId = false;
            // Cadena a devolver
            Respuesta respuesta = new Respuesta("ObtenerRegistros");
            using (var connection = new SqlConnection(connectionString))
            {
                var command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;
                command.CommandTimeout = 0;

                if (parameters != null)
                {
                    foreach (SqlParameter param in parameters)
                    {
                        if (param.ParameterName.Equals("@Id"))
                        {
                            if (param.SqlValue != null)
                            {
                                tieneBusquedaId = true;
                            }
                        }
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


                // Mapea las columnas a las propiedades de T
                var properties = typeof(T).GetProperties().ToDictionary(p => p.Name, StringComparer.OrdinalIgnoreCase);

                // Obtiene el resultado de la ejecución
                while (reader.Read())
                {
                    // Crea una instancia de T
                    T instance = Activator.CreateInstance<T>();

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        // Obtiene el nombre de la columna
                        string columnName = reader.GetName(i);

                        if (properties.TryGetValue(columnName, out var propertyInfo))
                        {
                            if (columnName.Equals(propertyInfo.Name))
                            {
                                // Verifica si la propiedad es de tipo string
                                if (reader[i].GetType() == typeof(string))
                                {
                                    // Si encuentra alguna propiedad que albergue un json con un solo objeto
                                    if (reader[i].ToString().Contains("{") && reader[i].ToString().EndsWith("}") && IsValidJson(reader[i].ToString()))
                                    {
                                        try
                                        {
                                            propertyInfo.SetValue(instance, reader[i] == DBNull.Value ? null : JsonConvert.DeserializeObject(reader[i].ToString(), propertyInfo.PropertyType));

                                        }
                                        catch (Exception e)
                                        {

                                        }
                                        finally
                                        {
                                            if (propertyInfo.GetValue(instance) == null)
                                            {
                                                propertyInfo.SetValue(instance, reader[i] == DBNull.Value ? null : reader[i]);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        propertyInfo.SetValue(instance, reader[i] == DBNull.Value ? null : reader[i].ToString());
                                    }
                                    // Asigna el valor de la columna a la propiedad correspondiente en T
                                }
                                else
                                {
                                    // Puedes manejar otros tipos de datos según sea necesario
                                    // Aquí, simplemente asignamos el valor directamente
                                    propertyInfo.SetValue(instance, reader[i] == DBNull.Value ? null : reader[i]);
                                }
                            }
                        }
                    }
                    // Agrega la instancia a la lista
                    list.Add(instance);

                    respuesta.Data = tieneBusquedaId == false ? list : list.First();
                }

                // Avanza a la siguiente consulta (TotalRows)
                if (reader.NextResult())
                {
                    // Verifica si hay filas en la siguiente consulta
                    if (reader.Read())
                    {
                        // Obtiene el valor de "TotalRows" de la segunda consulta
                        int totalRows = reader["TotalRows"] != DBNull.Value ? (int)reader["TotalRows"] : 0;

                        respuesta.TotalRows = totalRows;
                    }
                }

                // Cierra la conexión y libera recursos de la memoria
                connection.Close();
                respuesta.timeMeasure.Stop();
                //respuesta.sTiempos = respuesta.timeMeasure.ElapsedMilliseconds;
            }
            // Devuelve la cadena de respuesta
            return respuesta;
        }

        public int SpExecute(string storedProcedureName, IEnumerable<SqlParameter>? parameters = null, IEnumerable<SqlParameter>? outParameters = null)
        {
            var result = 0;
            using (var connection = new SqlConnection(connectionString))
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

        public void Dispose()
        {
            GC.Collect();
        }

        private static string GetConnectionString(string connectionStringName)
        {
            var environmentName = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

            var builder = new ConfigurationBuilder()
                            .SetBasePath(AppContext.BaseDirectory)
                            .AddJsonFile($"appsettings.json", true, true)
                            .AddJsonFile($"appsettings.{environmentName}.json", true, true)
                            .AddEnvironmentVariables();

            IConfigurationRoot configuration = builder.Build();
            return configuration.GetConnectionString(connectionStringName) ?? string.Empty;
        }

        // Función para validar si una cadena es un JSON válido
        private bool IsValidJson(string input)
        {
            try
            {
                JToken.Parse(input);
                return true;
            }
            catch (JsonReaderException)
            {
                return false;
            }
        }
    }
}
