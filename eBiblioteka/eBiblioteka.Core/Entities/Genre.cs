
namespace eBiblioteka.Core
{
    public class Genre : BaseEntity
    {
        public string Name { get; set; } = null!;
        public string Abbreviation { get; set; } = null!;

        public ICollection<BookGenre> Books { get; set; } = null!;
    }
}
