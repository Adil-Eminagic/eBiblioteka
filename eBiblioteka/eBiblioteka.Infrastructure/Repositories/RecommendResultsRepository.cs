
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;

namespace eBiblioteka.Infrastructure
{
    public class RecommendResultsRepository : IRecommendResultsRepository
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<RecommendResult> DbSet;
        private readonly IBooksRepository _booksRepository;

        public RecommendResultsRepository(DatabaseContext databaseContext, IBooksRepository booksRepository)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<RecommendResult>();
            _booksRepository = booksRepository;
        }

        public async Task CreateNewRecommendation(List<RecommendResult> results, CancellationToken cancellationToken = default)
        {
            var list = await DbSet.ToListAsync();
            ReportInfo<Book> book = await _booksRepository.GetCountAsync(new BooksSearchObject { PageSize=100000}, cancellationToken);
            var bookCount = book.TotalCount;
            var recordCount = await DbSet.CountAsync();

            if (recordCount != 0)
            {
                if (recordCount > bookCount)
                {
                    for (int i = 0; i < bookCount; i++)
                    {
                        list[i].BookId = results[i].BookId;
                        list[i].FirstCobookId = results[i].FirstCobookId;
                        list[i].SecondCobookId = results[i].SecondCobookId;
                        list[i].ThirdCobookId = results[i].ThirdCobookId;
                    }

                    for (int i = bookCount; i < recordCount; i++)
                    {
                         DbSet.Remove(list[i]);
                    }


                }
                else
                {
                    for (int i = 0; i < DbSet.Count(); i++)
                    {
                        list[i].BookId = results[i].BookId;
                        list[i].FirstCobookId = results[i].FirstCobookId;
                        list[i].SecondCobookId = results[i].SecondCobookId;
                        list[i].ThirdCobookId = results[i].ThirdCobookId;
                    }
                    var num = results.Count() - DbSet.Count();

                    if (num > 0)
                    {
                        for (int i = results.Count() - num; i < results.Count(); i++)
                        {
                           await DbSet.AddAsync(results[i]);
                        }
                    }
                }

            }
            else
            {
                await DbSet.AddRangeAsync(results);

            }

        }

        public async Task DeleteAllRecommendation(CancellationToken cancellationToken = default)
        {
            await DbSet.ExecuteDeleteAsync(cancellationToken);
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
