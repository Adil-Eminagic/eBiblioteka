﻿
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class BookGenresSearchObject : BaseSearchObject
    {
        public int? BookId { get; set; }
        public int? GenreId { get; set; }
        public bool? IsActive { get; set; }
    }
}
