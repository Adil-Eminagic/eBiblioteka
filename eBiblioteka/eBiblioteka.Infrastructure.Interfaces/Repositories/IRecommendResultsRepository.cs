
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces 
{
    public interface IRecommendResultsRepository // this reposizory doesn't inherit base repository
    {
        Task<RecommendResult?> GetByIdAsync(int bookId, CancellationToken cancellationToken = default);
        Task<PagedList<RecommendResult>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task CreateNewRecommendation(List<RecommendResult> results, CancellationToken cancellationToken = default);

       

    }
}
