
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
            return await DbSet.Where(c => searchObject.FullName == null || c.FirstName.ToLower().Contains(searchObject.FullName.ToLower())
            || c.LastName.ToLower().Contains(searchObject.FullName.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
