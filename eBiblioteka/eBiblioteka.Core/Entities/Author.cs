

namespace eBiblioteka.Core
{
    public class Author :BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public Gender Gender { get; set; }
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }
        public DateTime? MortalDate { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public ICollection<Book> Books { get; set; } = null!;
    }
}
