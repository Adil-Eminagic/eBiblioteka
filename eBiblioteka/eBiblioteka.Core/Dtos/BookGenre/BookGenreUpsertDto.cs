
namespace eBiblioteka.Core
{
    public class BookGenreUpsertDto:BaseUpsertDto
    {
        public int BookId { get; set; }

        public int GenreId { get; set; }
    }
}
