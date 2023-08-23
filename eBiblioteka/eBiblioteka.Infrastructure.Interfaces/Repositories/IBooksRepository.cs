
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces
{
    public interface IBooksRepository : IBaseRepository<Book, int, BooksSearchObject>
    {
        List<Book> GetExceptById(int id);
        List<Book> GetAll();

    }
}
