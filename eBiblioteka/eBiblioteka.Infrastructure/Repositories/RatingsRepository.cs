
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

        public async Task<double> GetBookAverageRatingAsync(int bookId, CancellationToken cancellationToken = default)
        {
            var ratings = await DbSet.Where(c => c.BookId == bookId).ToListAsync();

            if (ratings == null)
                throw new Exception("Error getting book rates");

            if (ratings.Count() == 0)
                return 0;
            else
            {
                double rate = 0;
                foreach (var rating in ratings)
                {
                    rate += rating.Stars;
                }
                return rate / ratings.Count();
            }

        }

        public override async Task<PagedList<Rating>> GetPagedAsync(RatingsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
           Where(c => searchObject.BookId == null || searchObject.BookId == c.BookId).
           Where(c => searchObject.Stars == null || c.Stars == searchObject.Stars).Include(c => c.User).Include(c => c.Book).
           Where(c => searchObject.UserName == null || (c.User.FirstName.ToLower().Contains(searchObject.UserName.ToLower()) ||
           c.User.LastName.ToLower().Contains(searchObject.UserName.ToLower()))).
            ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<Rating>> GetCountAsync(RatingsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
           Where(c => searchObject.BookId == null || searchObject.BookId == c.BookId).
           Where(c => searchObject.Stars == null || c.Stars == searchObject.Stars).Include(c => c.User).Include(c => c.Book).
           Where(c => searchObject.UserName == null || (c.User.FirstName.ToLower().Contains(searchObject.UserName.ToLower()) ||
           c.User.LastName.ToLower().Contains(searchObject.UserName.ToLower()))).
            ToReportInfoAsync(searchObject, cancellationToken);
        }

    }
}
