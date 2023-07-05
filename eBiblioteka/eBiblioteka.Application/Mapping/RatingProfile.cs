using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RatingProfile : BaseProfile
    {
        public RatingProfile()
        {
            CreateMap<RatingDto, Rating>().ReverseMap();

            CreateMap<RatingUpsertDto, Rating>();
        }
    }
}
