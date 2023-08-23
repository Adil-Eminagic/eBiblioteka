using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IUserQuizsService : IBaseService<int, UserQuizDto, UserQuizUpsertDto, UserQuizsSearchObject>
    {
    }
}
