using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuoteProfile : BaseProfile
    {
        public QuoteProfile()
        {
            CreateMap<QuoteDto, Quote>().ReverseMap();

            CreateMap<QuoteUpsertDto, Quote>();
        }
    }
}
