
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface IRecommendResultsRepository
    {
        Task<RecommendResult?> GetByIdAsync(int bookId, CancellationToken cancellationToken = default);
        Task<PagedList<RecommendResult>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task CreateNewRecommendation(List<RecommendResult> results, CancellationToken cancellationToken = default);
        void UpdateRecommendation(List<RecommendResult> results);

    }
}
