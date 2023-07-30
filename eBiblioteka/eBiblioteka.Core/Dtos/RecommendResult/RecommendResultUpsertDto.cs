
namespace eBiblioteka.Core
{
    public class RecommendResultUpsertDto:BaseUpsertDto
    {
        public int BookId { get; set; }
        public int FirstCobookId { get; set; }
        public int SecondCobookId { get; set; }
        public int ThirdCobookId { get; set; }
    }
}
