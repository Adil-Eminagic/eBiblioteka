
namespace eBiblioteka.Core
{
    public class UserBookDto:BaseDto
    {
        public int BookId { get; set; }
        public BookDto Book { get; set; } = null!;

        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;
    }
}
