using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuizProfile : BaseProfile
    {
        public QuizProfile()
        {
            CreateMap<QuizDto, Quiz>().ReverseMap();

            CreateMap<QuizUpsertDto, Quiz>();
        }
    }
}
