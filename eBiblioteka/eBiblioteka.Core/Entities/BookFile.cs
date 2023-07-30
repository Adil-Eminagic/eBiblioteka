
namespace eBiblioteka.Core
{
    public class BookFile :BaseEntity
    {
        public string Name { get; set; } = null!;

        public string Data { get; set; } = null!;

        public ICollection<Book> Books { get; set; } = null!;
    }
}
