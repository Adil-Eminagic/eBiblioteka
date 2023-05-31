using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class CityProfile : BaseProfile
    {
        public CityProfile()
        {
            CreateMap<CityDto, City>().ReverseMap();

            CreateMap<CityUpsertDto, City>();
        }
    }
}
