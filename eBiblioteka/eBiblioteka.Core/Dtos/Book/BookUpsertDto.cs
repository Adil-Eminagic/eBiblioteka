namespace eBiblioteka.Core
{
    public class BookUpsertDto : BaseUpsertDto
    {
        public string Title { get; set; } = null!;
        public string? ShortDescription { get; set; } = null!;
        public int? PublishingYear { get; set; }
        public int OpeningCount { get; set; }
        public bool isActive { get; set; }
        public string? image { get; set; }

        public BookFileUpsertDto? document { get; set; }

        public int AuthorID { get; set; }
    }
}
