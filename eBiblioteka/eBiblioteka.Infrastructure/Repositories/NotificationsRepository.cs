
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class NotificationsRepository : BaseRepository<Notification, int, NotificationsSearchObject>, INotificationsRepository
    {
        public NotificationsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Notification>> GetPagedAsync(NotificationsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(c=> searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c=> searchObject.isRead==null || c.isRead==searchObject.isRead)
                .Where(c=> searchObject.UserId==c.UserId || searchObject.UserId ==null)    
            .ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
