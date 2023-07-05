using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class GenderProfile : BaseProfile
    {
        public GenderProfile()
        {
            CreateMap<GenderDto, Gender>().ReverseMap();

            CreateMap<GenderUpsertDto, Gender>();
        }
    }
}
