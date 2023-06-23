
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Infrastructure
{
    public class BookGenreGenresRepository : BaseRepository<BookGenre, int, BaseSearchObject>, IBookGenresRepository
    {
        public BookGenreGenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }
    }
}
