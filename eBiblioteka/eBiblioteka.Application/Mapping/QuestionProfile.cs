using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuestionProfile : BaseProfile
    {
        public QuestionProfile()
        {
            CreateMap<QuestionDto, Question>().ReverseMap();

            CreateMap<QuestionUpsertDto, Question>();
        }
    }
}
