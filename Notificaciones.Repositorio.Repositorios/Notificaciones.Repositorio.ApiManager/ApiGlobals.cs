using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.ApiManager
{
    public class ApiGlobals
    {
        private readonly IConfiguration configuration;

        public ApiGlobals(IConfiguration configuration)
        {
            this.configuration = configuration;
        }
        public string ApiWMSAdminUrl => configuration["ApiWMSAdminUrl"] != null
            ? configuration["ApiWMSAdminUrl"].ToString()
            : throw new ApplicationException("ApiWMSAdminUrl no existe en el archivo de comfiguración");
    }
}
