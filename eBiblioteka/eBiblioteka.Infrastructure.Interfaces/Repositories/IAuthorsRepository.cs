
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface IAuthorsRepository : IBaseRepository<Author, int, AuthorsSearchObject>
    {
    }
}
