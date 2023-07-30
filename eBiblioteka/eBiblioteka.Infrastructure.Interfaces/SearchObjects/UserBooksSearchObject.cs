
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class UserBooksSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? BookId { get; set; }
    }
}
