
namespace eBiblioteka.Core
{
    public class RecommendResultDto :BaseDto
    {
        public int BookId { get; set; }
        public int FirstCobookId { get; set; }
        public int SecondCobookId { get; set; }
        public int ThirdCobookId { get; set; }
    }
}
