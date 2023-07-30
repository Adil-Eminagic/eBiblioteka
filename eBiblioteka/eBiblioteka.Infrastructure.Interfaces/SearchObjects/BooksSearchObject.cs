namespace eBiblioteka.Infrastructure.Interfaces
{
    public class BooksSearchObject : BaseSearchObject
    {
        public string? Title { get; set; }
        public string? AuthorName { get; set; }
        public bool Descending { get; set; } = false;
        public bool? isActive { get; set; }

    }
}