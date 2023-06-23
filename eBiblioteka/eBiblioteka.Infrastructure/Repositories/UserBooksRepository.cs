using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class UserBooksRepository : BaseRepository<UserBook, int, BaseSearchObject>, IUserBooksRepository
    {
        public UserBooksRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

    }
}
