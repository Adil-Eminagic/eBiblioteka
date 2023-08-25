namespace eBiblioteka.Core
{
    public class BookUpsertDto : BaseUpsertDto
    {
        public string Title { get; set; } = null!;
        public string? ShortDescription { get; set; } = null!;
        public int? PublishingYear { get; set; }
        public int OpeningCount { get; set; }
        public string? Image { get; set; }

        public BookFileUpsertDto? Document { get; set; }

        public int AuthorID { get; set; }
    }
}
