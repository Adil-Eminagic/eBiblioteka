using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookGenreProfile : BaseProfile
    {
        public BookGenreProfile()
        {
            CreateMap<BookGenreDto, BookGenre>().ReverseMap();

            CreateMap<BookGenreUpsertDto, BookGenre>();
        }
    }
}
