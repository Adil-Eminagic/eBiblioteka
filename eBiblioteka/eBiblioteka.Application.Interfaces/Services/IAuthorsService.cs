using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IAuthorsService : IBaseService<int, AuthorDto, AuthorUpsertDto, AuthorsSearchObject>
    {
    }
}
