
namespace eBiblioteka.Core
{
    public class RatingDto:BaseDto
    {
        public int Stars { get; set; }
        public string? Comment { get; set; }
        public DateTime DateTime { get; set; }

        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;

        public int BookId { get; set; }
        public BookDto Book { get; set; } = null!;
    }
}
