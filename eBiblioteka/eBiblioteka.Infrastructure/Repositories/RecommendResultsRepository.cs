
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

            var list = DbSet.ToList();
            if (DbSet.Count() != 0)
            {
                for (int i = 0; i < DbSet.Count(); i++)
                {
                    list[i].BookId = results[i].BookId;
                    list[i].FirstCobookId = results[i].FirstCobookId;
                    list[i].SecondCobookId = results[i].SecondCobookId;
                    list[i].ThirdCobookId = results[i].ThirdCobookId;
                }
                //var num = results.Count() - DbSet.Count();

                //if (num>0)
                //{
                //    for(int i = results.Count() - num;i < results.Count(); i++)
                //    {
                //        list.Add(results[i]);
                //    }
                //}
            }
            else
            {
                await DbSet.AddRangeAsync(results);

            }

        }

        public async Task<RecommendResult?> GetByIdAsync(int bookId, CancellationToken cancellationToken = default)
        {
            return await DbSet.FirstOrDefaultAsync(c=>c.BookId==bookId);
        }

        public async Task<PagedList<RecommendResult>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }

        public void UpdateRecommendation(List<RecommendResult> results)
        {
            if (DbSet.Count() != 0)
            {
                DbSet.UpdateRange(results);
            }
            else
            {
                DbSet.AddRange(results);
            }
        }
    }
}
