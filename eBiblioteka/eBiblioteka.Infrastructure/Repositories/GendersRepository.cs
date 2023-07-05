
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class GendersRepository : BaseRepository<Gender, int, BaseSearchObject>, IGendersRepository
    {
        public GendersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
