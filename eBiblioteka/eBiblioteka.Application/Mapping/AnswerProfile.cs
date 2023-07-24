using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class AnswerProfile : BaseProfile
    {
        public AnswerProfile()
        {
            CreateMap<AnswerDto, Answer>().ReverseMap();

            CreateMap<AnswerUpsertDto, Answer>();
        }
    }
}
