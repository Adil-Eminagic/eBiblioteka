using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IAnswersService : IBaseService<int, AnswerDto, AnswerUpsertDto, AnswersSearchObject>
    {
    }
}
