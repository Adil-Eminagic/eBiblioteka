
namespace eBiblioteka.Core
{
    public class AuthorDto:BaseDto
    {
        public string FullName { get; set; } = null!;
        public string? Biography { get; set; }
        public int BirthYear { get; set; }
        public int? MortalYear { get; set; }

        public int? PhotoId { get; set; }
        public PhotoDto? Photo { get; set; }

        public int CountryId { get; set; }
        public CountryDto Country { get; set; }=null!;

        public int GenderId { get; set; }
        public GenderDto Gender { get; set; } = null!;
    }
}
