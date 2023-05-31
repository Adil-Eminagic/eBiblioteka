
namespace eBiblioteka.Core
{
    public class Book : BaseEntity
    {
        public string Title { get; set; } = null!;
        public string? ShortDescription { get; set; } = null!;
        public DateTime PublishingDate { get; set; }
        public int OpeningCount { get; set; }

        public int CoverPhotoId { get; set; }
        public Photo CoverPhoto { get; set; } = null!;

        public ICollection<Quote> Quotes { get; set; } = null!;
    }
}
