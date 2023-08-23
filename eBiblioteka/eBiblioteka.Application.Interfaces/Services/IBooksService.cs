using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IBooksService : IBaseService<int, BookDto, BookUpsertDto, BooksSearchObject>
    {
        Task<BookDto> OpenBookAsync(int bookId, CancellationToken cancellationToken);
    }
}
