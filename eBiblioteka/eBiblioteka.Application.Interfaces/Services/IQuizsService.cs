using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IQuizsService : IBaseService<int, QuizDto, QuizUpsertDto, QuizzesSearchObject>
    {
    }
}
