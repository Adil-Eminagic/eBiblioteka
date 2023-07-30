
namespace eBiblioteka.Core
{
    public class RatingUpsertDto:BaseUpsertDto
    {
        public int Stars { get; set; }
        public string? Comment { get; set; }

        public int UserId { get; set; }

        public int BookId { get; set; }
    }
}
