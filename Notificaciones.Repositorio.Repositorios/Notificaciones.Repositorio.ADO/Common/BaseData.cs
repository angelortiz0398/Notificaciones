using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.ADO.Common
{
    public class BaseData : IBaseData
    {
        public IAccessor accesor { get; set; }

        public BaseData()
        {
            accesor = new Accessor(DataGlobals.BDConnectionString);
        }

        public BaseData(string cnnStringName)
        {
            accesor = new Accessor(cnnStringName);
        }

        public void Dispose()
        {
            GC.Collect();
        }
    }
}
