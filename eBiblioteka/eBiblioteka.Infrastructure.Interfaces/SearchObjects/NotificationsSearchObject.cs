
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class NotificationsSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }
        public bool? isRead { get; set; }
        public int? UserId { get; set; }

    }
}
