using System;
using System.Diagnostics;

namespace Notificaciones.Modelo.Entidades.Generales
{
    public class Respuesta : IDisposable
    {
        public Stopwatch timeMeasure = new Stopwatch();

        public int? TotalRows { get; set; }

        public int? PageIndex { get; set; }

        public int? PageSize { get; set; }

        public int Status { get; set; }

        public string? Message { get; set; }

        public object? Data { get; set; }

        public string? Function { get; set; }

        public object? Parameters { get; set; }

        public string sTiempos => $"Tiempo de ejecución: {timeMeasure.Elapsed.TotalSeconds} s";

        public Respuesta()
        {
            Status = 200;
        }

        public Respuesta(string Function)
        {
            Status = 200;
            Message = "Proceso ejecutado correctamente";
            this.Function = Function;
            timeMeasure.Start();
        }

        public void Exception(Exception exception)
        {
            Status = 500;
            Message = exception.Message;
            timeMeasure.Stop();
        }

        public void Dispose()
        {
            timeMeasure.Stop();
        }
    }
}
