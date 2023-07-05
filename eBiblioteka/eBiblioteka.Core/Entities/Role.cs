
namespace eBiblioteka.Core
{
    public class Role : BaseEntity
    {
        public string Value { get; set; } = null!;

        public ICollection<User> Users { get; set; } = null!;
    }
}
