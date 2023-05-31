
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class BooksRepository : BaseRepository<Book, int, BooksSearchObject>, IBooksRepository
    {
        public BooksRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Book>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.CoverPhoto).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
               .ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
