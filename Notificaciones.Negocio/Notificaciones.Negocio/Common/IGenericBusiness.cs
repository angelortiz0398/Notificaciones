using System.Collections.Generic;

namespace Notificaciones.Negocio.Common
{
    public interface IGenericBusiness<T1>
    {
        long Create(T1 item);
        long Update(T1 item);
        long Delete(T1 item);
        T1 GetId(long nId);
        IEnumerable<T1> GetAll();
    }
}
