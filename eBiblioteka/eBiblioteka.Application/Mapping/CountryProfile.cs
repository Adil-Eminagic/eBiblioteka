using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class CountryProfile : BaseProfile
    {
        public CountryProfile()
        {
            CreateMap<CountryDto, Country>().ReverseMap();

            CreateMap<CountryUpsertDto, Country>();
        }
    }
}
