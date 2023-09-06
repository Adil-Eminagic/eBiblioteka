
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class RecommendResultsRepository : IRecommendResultsRepository
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<RecommendResult> DbSet;

        public RecommendResultsRepository(DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<RecommendResult>();
        }

        public async Task CreateNewRecommendation(List<RecommendResult> results, CancellationToken cancellationToken = default)
        {
            await DbSet.AddRangeAsync(results);
        }

        public async Task<RecommendResult?> GetByIdAsync(int bookId, CancellationToken cancellationToken = default)
        {
            return await DbSet.FirstOrDefaultAsync(c => c.BookId == bookId);
        }

        public async Task<PagedList<RecommendResult>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }


    }
}
