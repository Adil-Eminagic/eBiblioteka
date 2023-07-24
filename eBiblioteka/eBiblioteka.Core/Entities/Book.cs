
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


        public ICollection<BookGenre> Genres { get; set; } = null!;
        public ICollection<Quote> Quotes { get; set; } = null!;
        public ICollection<UserBook> Readers { get; set; } = null!;
        public ICollection<Rating> UserRate { get; set; }=null!;


        //public int AverageRate
        //{
        //    get
        //    {
        //        if (UserRate.Count == 0)
        //            return 0;
        //        int ave = 0;
        //        foreach (var item in UserRate)
        //            ave += item.Stars;
        //        return (ave / UserRate.Count);

        //    }
        //    set { }
        //}
    }
}
