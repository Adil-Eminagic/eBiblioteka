
namespace eBiblioteka.Core
{
    public class AuthorUpsertDto:BaseUpsertDto
    {
        public string FullName { get; set; } = null!;
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }
        public DateTime? MortalDate { get; set; }

        public int CountryId { get; set; }

        public int GenderId { get; set; }

    }
}
