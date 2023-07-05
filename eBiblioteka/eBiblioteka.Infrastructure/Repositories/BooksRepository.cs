
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

        public async Task<IEnumerable<Book>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken)
        {
            return await DbSet.AsNoTracking().Where(c=>c.AuthorID==authorId).ToListAsync(cancellationToken);
        }

        public override async Task<PagedList<Book>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.CoverPhoto).Include(c=>c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
               .ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
