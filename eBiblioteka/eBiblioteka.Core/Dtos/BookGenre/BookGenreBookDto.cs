
namespace eBiblioteka.Core
{
    public class BookGenreDto:BaseDto
    {
        public int BookId { get; set; }
        public Book Book { get; set; } = null!;

        public int GenreID { get; set; }
        public Role Genre { get; set; } = null!;
    }
}
