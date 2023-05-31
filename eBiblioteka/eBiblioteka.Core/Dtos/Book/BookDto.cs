namespace eBiblioteka.Core
{
    public class BookDto : BaseDto
    {
        public string Title { get; set; } = null!;
        public string ShortDescription { get; set; } = null!;
        public DateTime PublishingDate { get; set; }
        public int OpeningCount { get; set; }

        public int CoverPhotoId { get; set; }
        public Photo CoverPhoto { get; set; } = null!;

    }
}
