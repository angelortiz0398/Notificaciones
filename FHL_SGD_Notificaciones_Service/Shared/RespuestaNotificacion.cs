using System.Diagnostics;
using System;

namespace FHL_SGD_Notificaciones_Service.Shared
{
    public class RespuestaNotificacion : IDisposable
    {
        public Stopwatch timeMeasure = new Stopwatch();

        public int? TotalRows { get; set; }

        public int? PageIndex { get; set; }

        public int? PageSize { get; set; }

        public int Status { get; set; }

        public string Message { get; set; } = string.Empty;

        public object Data { get; set; } = null;

        public string Function { get; set; } = null;

        public object Parameters { get; set; } = null;

        public string sTiempos => $"Tiempo de ejecución: {timeMeasure.Elapsed.TotalSeconds} s";

        public RespuestaNotificacion()
        {
            Status = 200;
        }

        public RespuestaNotificacion(string Function)
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
