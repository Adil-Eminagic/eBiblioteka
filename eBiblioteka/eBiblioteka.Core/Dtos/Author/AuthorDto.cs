
namespace eBiblioteka.Core
{
    public class AuthorDto:BaseDto
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public Gender Gender { get; set; }
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }
        public DateTime? MortalDate { get; set; }

        public int CountryId { get; set; }
    }
}
