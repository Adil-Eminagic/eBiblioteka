using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IQuestionsService : IBaseService<int, QuestionDto, QuestionUpsertDto, QuestionsSearchObject>
    {
    }
}
