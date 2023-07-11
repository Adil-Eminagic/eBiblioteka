using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class GenreProfile : BaseProfile
    {
        public GenreProfile()
        {
            CreateMap<GenreDto, Genre>().ReverseMap();

            CreateMap<GenreUpsertDto, Genre>();
        }
    }
}
