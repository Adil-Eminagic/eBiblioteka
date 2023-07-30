using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IBooksService : IBaseService<int, BookDto, BookUpsertDto, BooksSearchObject>
    {
        Task<IEnumerable<BookDto>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken);
        Task<BookDto> OpenBookAsync(int bookId, CancellationToken cancellationToken);
        //List<BookDto> Recommend(int id);
        //public Task<List<object>> TrainBooksModel( CancellationToken cancellationToken = default);
        Task<BookDto> DeactivateAsync(int bookId, CancellationToken cancellationToken = default);
        Task<BookDto> ActivateAsync(int bookId, CancellationToken cancellationToken = default);

    }
}
