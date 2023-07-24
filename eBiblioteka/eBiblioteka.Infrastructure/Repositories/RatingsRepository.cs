
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class RatingsRepository : BaseRepository<Rating, int, RatingsSearchObject>, IRatingsRepository
    {
        public RatingsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Rating>> GetPagedAsync(RatingsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId==searchObject.UserId).
           Where(c => searchObject.BookId == null || searchObject.BookId==c.BookId).
           Where(c => searchObject.Stars == null || c.Stars == searchObject.Stars).Include(c=>c.User).Include(c=>c.Book).
           Where(c => searchObject.UserName == null || c.User.FirstName.ToLower().Contains(searchObject.UserName.ToLower()) ||
           c.User.LastName.ToLower().Contains(searchObject.UserName.ToLower())).
            ToPagedListAsync(searchObject, cancellationToken);
        }


    }
}
