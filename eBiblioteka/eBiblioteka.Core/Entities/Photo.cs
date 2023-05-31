namespace eBiblioteka.Core
{
    public class Photo : BaseEntity
    {
        public string Data { get; set; } = null!;
      

        public ICollection<Book> Books { get; set; } = null!;
    }
}
