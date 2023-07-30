
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Infrastructure
{
    public class BookFilesRepository : BaseRepository<BookFile, int, BaseSearchObject>, IBookFilesRepository
    {
        public BookFilesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
