namespace eBiblioteka.Core
{
    public class QuoteDto : BaseDto
    {
        public string Content { get; set; } = null!;

        public int BookId { get; set; }
        public BookDto Book { get; set; } = null!;
    }
}
