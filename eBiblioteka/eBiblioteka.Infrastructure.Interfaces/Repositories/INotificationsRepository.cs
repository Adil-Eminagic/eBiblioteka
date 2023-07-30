
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface INotificationsRepository : IBaseRepository<Notification, int, NotificationsSearchObject>
    {
    }
}
