using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.ADO.Common
{
    public interface IBaseData : IDisposable
    {
        IAccessor accesor { get; }
    }
}
