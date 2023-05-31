
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces
{
    public interface IQuotesRepository : IBaseRepository<Quote, int, QuotesSearchObject>
    {
        Task<IEnumerable<Quote>> GetByBookIdAsync(int bookId, CancellationToken cancellationToken = default);
    }
}
