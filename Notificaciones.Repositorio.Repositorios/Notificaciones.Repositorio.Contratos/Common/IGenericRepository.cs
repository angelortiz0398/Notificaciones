using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Notificaciones.Repositorio.Contratos.Common
{
    public interface IGenericRepository<T1>
    {
        long Create(T1 item);
        long Update(T1 item);
        long Delete(T1 item);
        T1 GetId(long nId);
        List<T1> GetAll();
    }
}
