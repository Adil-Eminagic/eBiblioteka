using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface INotificationsService : IBaseService<int, NotificationDto, NotificationUpsertDto, NotificationsSearchObject>
    {
        Task ReadNotification(int notificationId, CancellationToken cancellationToken=default);//to change isRead to true if it is false
    }
}
