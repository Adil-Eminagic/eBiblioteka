
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IRecommendResultsService 
    {
        Task<RecommendResultDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<PagedList<RecommendResultDto>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task<List<RecommendResultDto>> TrainBooksModelAsync(CancellationToken cancellationToken = default);

        Task DeleteAllRecommendation(CancellationToken cancellationToken = default);
        


    }
}
