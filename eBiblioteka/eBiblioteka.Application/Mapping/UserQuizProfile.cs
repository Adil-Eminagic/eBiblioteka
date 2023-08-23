using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserQuizProfile : BaseProfile
    {
        public UserQuizProfile()
        {
            CreateMap<UserQuizDto, UserQuiz>().ReverseMap();

            CreateMap<UserQuizUpsertDto, UserQuiz>();
        }
    }
}
