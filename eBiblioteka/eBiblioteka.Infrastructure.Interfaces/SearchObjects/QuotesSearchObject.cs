
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class QuotesSearchObject : BaseSearchObject
    {
        public string? Content { get; set; }
        public int? BookId { get; set; }

    }
}
