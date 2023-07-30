
namespace eBiblioteka.Core
{
    public class RecommendResult:BaseEntity
    {
        public int BookId { get; set; }
        public int FirstCobookId { get; set; }
        public int SecondCobookId { get; set; }
        public int ThirdCobookId { get; set; }
    }
}
