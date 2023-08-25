
namespace eBiblioteka.Core
{
    public class AuthorUpsertDto:BaseUpsertDto
    {
        public string FullName { get; set; } = null!;
        public string? Biography { get; set; }
        public int BirthYear { get; set; }
        public int? MortalYear { get; set; }

        public string? Image { get; set; }

        public int CountryId { get; set; }

        public int GenderId { get; set; }

    }
}
