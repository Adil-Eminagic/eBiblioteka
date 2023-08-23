
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;


namespace eBiblioteka.Infrastructure
{
    public class AuthorsRepository : BaseRepository<Author, int, AuthorsSearchObject>, IAuthorsRepository
    {
        public AuthorsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Author>> GetPagedAsync(AuthorsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.Photo).Include(c=>c.Gender).Where(c => searchObject.FullName == null || c.FullName.ToLower().Contains(searchObject.FullName.ToLower())
            ).ToPagedListAsync(searchObject, cancellationToken);
        }

        public override async Task<ReportInfo<Author>> GetCountAsync(AuthorsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.Gender).Where(c => searchObject.FullName == null || c.FullName.ToLower().Contains(searchObject.FullName.ToLower())
            ).ToReportInfoAsync(searchObject, cancellationToken);
        }


    }
}
