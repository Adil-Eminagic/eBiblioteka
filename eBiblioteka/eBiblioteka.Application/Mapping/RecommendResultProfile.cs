using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RecommendResultProfile : BaseProfile
    {
        public RecommendResultProfile()
        {
            CreateMap<RecommendResultDto, RecommendResult>().ReverseMap();

            CreateMap<RecommendResultUpsertDto, RecommendResult>();
        }
    }
}
