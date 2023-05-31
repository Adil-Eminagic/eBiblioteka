
namespace eBiblioteka.Core
{
    public class Quote : BaseEntity
    {
        public string Content { get; set; } = null!;

        public int BookId { get; set; }
        public Book Book { get; set; } = null!;
    }
}
