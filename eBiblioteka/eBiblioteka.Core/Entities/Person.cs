
namespace eBiblioteka.Core.Entities
{
    public abstract class Person : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public Gender Gender { get; set; }
    }
}
