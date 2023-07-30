using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookFileProfile : BaseProfile
    {
        public BookFileProfile()
        {
            CreateMap<BookFileDto, BookFile>().ReverseMap();

            CreateMap<BookFileUpsertDto, BookFile>();
        }
    }
}
