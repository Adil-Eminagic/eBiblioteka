
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface IQuestionsRepository : IBaseRepository<Question, int, QuestionsSearchObject>
    {
    }
}
