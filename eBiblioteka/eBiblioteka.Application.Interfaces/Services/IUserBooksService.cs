using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IUserBooksService : IBaseService<int, UserBookDto, UserBookUpsertDto, BaseSearchObject>
    {
    }
}
