namespace eBiblioteka.Core
{
    public class BookDto : BaseDto
    {
        public string Title { get; set; } = null!;
        public string ShortDescription { get; set; } = null!;
        public int? PublishingYear { get; set; }
        public int OpeningCount { get; set; }

        public int? CoverPhotoId { get; set; }
        public PhotoDto? CoverPhoto { get; set; } = null!;

        public int AuthorID { get; set; }
        public Author Author { get; set; } = null!;

    }
}
