using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class NotificationsService : BaseService<Notification, NotificationDto, NotificationUpsertDto, NotificationsSearchObject, INotificationsRepository>, INotificationsService
    {
        public NotificationsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<NotificationUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
        }

        public async Task ReadNotification(int notificationId, CancellationToken cancellationToken=default)
        {
            var notification= await CurrentRepository.GetByIdAsync(notificationId);

            if (notification == null)
                throw new Exception("Notification not found");

            if (notification.IsRead == true) throw new Exception("Cann't change read notification to read");

            notification.IsRead = true;

             CurrentRepository.Update(notification);
            await UnitOfWork.SaveChangesAsync();

            
        }
    }
}
