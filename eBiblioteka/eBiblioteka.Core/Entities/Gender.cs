
namespace eBiblioteka.Core
{
    public class Gender:BaseEntity
    {
        public string Value { get; set; } = null!;

        public ICollection<User> Users { get; set; }=null!;
        public ICollection<Author> Authors { get; set; } = null!;
    }
}
