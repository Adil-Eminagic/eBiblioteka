
namespace eBiblioteka.Core
{
    public class UserBookUpsertDto:BaseUpsertDto
    {
        public int BookId { get; set; }

        public int UserId { get; set; }
    }
}
