using NotificacionesService;
using System.ServiceProcess;

namespace FHL_SGD_Notificaciones_Service
{
    public static class Program
    {
        /// <summary>
        /// Punto de entrada principal para la aplicación.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;
            ServicesToRun = new ServiceBase[]
            {
                        new NotificacionService()
            };
            ServiceBase.Run(ServicesToRun);
        }
    }
}
