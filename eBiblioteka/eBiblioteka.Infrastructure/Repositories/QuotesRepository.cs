
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading;

namespace eBiblioteka.Infrastructure
{
    public class QuotesRepository : BaseRepository<Quote, int, QuotesSearchObject>, IQuotesRepository
    {
        public QuotesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Quote>> GetPagedAsync(QuotesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c=>searchObject.BookId== null || searchObject.BookId==c.BookId)
               .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async Task<IEnumerable<Quote>> GetByBookIdAsync(int bookId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c => c.BookId == bookId).ToListAsync(cancellationToken);
        }

        public async override Task<ReportInfo<Quote>> GetCountAsync(QuotesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c => searchObject.BookId == null || searchObject.BookId == c.BookId)
               .ToReportInfoAsync(searchObject, cancellationToken);
        }
    }
}
