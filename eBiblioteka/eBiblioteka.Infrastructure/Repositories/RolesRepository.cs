
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class RolesRepository : BaseRepository<Role, int, BaseSearchObject>, IRolesRepository
    {
        public RolesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async override Task<PagedList<Role>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(s=>s.Id>1).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
