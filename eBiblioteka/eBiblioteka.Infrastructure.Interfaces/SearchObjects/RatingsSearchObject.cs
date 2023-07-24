
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class RatingsSearchObject : BaseSearchObject
    {
        public int? Stars { get; set; }
        public int? UserId { get; set; }
        public int? BookId { get; set; }
        public string UserName { get; set; }
    }
}
