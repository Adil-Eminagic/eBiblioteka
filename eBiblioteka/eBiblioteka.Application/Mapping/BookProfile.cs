using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookProfile : BaseProfile
    {
        public BookProfile()
        {
            CreateMap<BookDto, Book>().ReverseMap();

            CreateMap<BookUpsertDto, Book>()
                .ForMember(c=>c.CoverPhoto, o=>o.Ignore());
        }
    }
}
