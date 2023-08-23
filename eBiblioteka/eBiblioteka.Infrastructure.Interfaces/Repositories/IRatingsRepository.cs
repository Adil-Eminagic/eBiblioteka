
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface IRatingsRepository : IBaseRepository<Rating, int, RatingsSearchObject>
    {
        Task<double> GetBookAverageRatingAsync(int bookId, CancellationToken cancellationToken=default);
    }
}
