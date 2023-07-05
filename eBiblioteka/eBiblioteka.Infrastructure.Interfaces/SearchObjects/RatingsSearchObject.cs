
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class RatingsSearchObject : BaseSearchObject
    {
        public int? Stars { get; set; }
        public string? UserName { get; set; }
        public string? BookTitle { get; set; }
    }
}
