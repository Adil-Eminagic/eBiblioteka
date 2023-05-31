namespace eBiblioteka.Core
{
    public class QuoteUpsertDto : BaseUpsertDto
    {
        public string Content { get; set; } = null!;

        public int BookId { get; set; }
    }
}
