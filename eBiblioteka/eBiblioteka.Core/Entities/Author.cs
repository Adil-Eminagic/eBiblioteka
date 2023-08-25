
namespace eBiblioteka.Core
{
    public class Author :BaseEntity
    {
        public string FullName { get; set; } = null!;
        public string? Biography { get; set; }
        public int BirthYear { get; set; }
        public int? MortalYear { get; set; }

        public int? PhotoId { get; set; }
        public Photo? Photo { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public int GenderId { get; set; }
        public Gender Gender { get; set; } = null!;

        public ICollection<Book> Books { get; set; } = null!;
    }
}
