
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces
{
    public interface IBookGenresRepository : IBaseRepository<BookGenre,int, BookGenresSearchObject>
    {
    }
}
