using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class NotificationProfile : BaseProfile
    {
        public NotificationProfile()
        {
            CreateMap<NotificationDto, Notification>().ReverseMap();

            CreateMap<NotificationUpsertDto, Notification>();
        }
    }
}
