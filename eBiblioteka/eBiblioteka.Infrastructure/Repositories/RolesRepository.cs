
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class RolesRepository : BaseRepository<Role, int, BaseSearchObject>, IRolesRepository
    {
        public RolesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
       
    }
}
