
namespace eBiblioteka.Core
{
    public class Book : BaseEntity
    {
        public string Title { get; set; } = null!;
        public string? ShortDescription { get; set; } = null!;
        public int? PublishingYear { get; set; }
        public int OpeningCount { get; set; }

        public int? CoverPhotoId { get; set; }
        public Photo? CoverPhoto { get; set; } = null!;

        public int AuthorID { get; set; }
        public Author Author { get; set; } = null!;

        public int? BookFileId { get; set; }
        public BookFile? BookFile { get; set; } 


        public ICollection<BookGenre> Genres { get; set; } = null!;
        public ICollection<Quote> Quotes { get; set; } = null!;
        public ICollection<UserBook> Readers { get; set; } = null!;
        public ICollection<Rating> UserRate { get; set; }=null!;

    }
}
