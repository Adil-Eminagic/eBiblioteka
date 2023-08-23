using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class UserBooksRepository : BaseRepository<UserBook, int, UserBooksSearchObject>, IUserBooksRepository
    {
        public UserBooksRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }


        public override async Task<PagedList<UserBook>> GetPagedAsync(UserBooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
           Where(c => searchObject.BookId == null || searchObject.BookId == c.BookId).
            ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<UserBook>> GetCountAsync(UserBooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
            Where(c => searchObject.BookId == null || searchObject.BookId == c.BookId).
             ToReportInfoAsync(searchObject, cancellationToken);
        }
    }
}
