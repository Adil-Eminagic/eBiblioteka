namespace eBiblioteka.Core
{
    public class BookDto : BaseDto
    {
        public string Title { get; set; } = null!;
        public string? ShortDescription { get; set; } 
        public int? PublishingYear { get; set; }
        public int OpeningCount { get; set; }


        public int? CoverPhotoId { get; set; }
        public PhotoDto? CoverPhoto { get; set; } 

        public int? BookFileId { get; set; }
        public BookFileDto? BookFile { get; set; } 

        public int AuthorID { get; set; }
        public AuthorDto Author { get; set; } = null!;

    }
}
