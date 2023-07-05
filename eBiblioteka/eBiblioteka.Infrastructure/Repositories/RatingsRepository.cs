
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class RatingsRepository : BaseRepository<Rating, int, RatingsSearchObject>, IRatingsRepository
    {
        public RatingsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Rating>> GetPagedAsync(RatingsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserName == null || c.User.FirstName.ToLower().Contains(searchObject.UserName.ToLower())
            || (c.User.LastName != null && c.User.LastName.ToLower().Contains(searchObject.UserName.ToLower()))).
           Where(c => searchObject.BookTitle == null || c.Book.Title.ToLower().Contains(searchObject.BookTitle.ToLower())).
           Where(c => searchObject.Stars == null || c.Stars == searchObject.Stars).
            ToPagedListAsync(searchObject, cancellationToken);
        }


    }
}
