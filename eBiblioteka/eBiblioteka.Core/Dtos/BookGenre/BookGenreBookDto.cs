
namespace eBiblioteka.Core
{
    public class BookGenreDto:BaseDto
    {
        public int BookId { get; set; }
        public BookDto Book { get; set; } = null!;

        public int GenreId { get; set; }
        public GenreDto Genre { get; set; } = null!;
    }
}
