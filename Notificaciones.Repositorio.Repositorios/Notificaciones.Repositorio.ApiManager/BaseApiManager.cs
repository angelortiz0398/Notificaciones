using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.ApiManager
{
    public class BaseApiManager
    {
        internal string _apiUrl;
        internal AuthenticationHeaderValue _authorizationHeader;

        public BaseApiManager(string apiUrl, AuthenticationHeaderValue authorizationHeader)
        {
            _apiUrl = apiUrl;
            _authorizationHeader = authorizationHeader;
        }
    }
}
