
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

        public List<Book> GetAll()
        {
           return DbSet.ToList<Book>();
        }


        public override async Task<Book?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.UserRate).FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
        }

        public async Task<IEnumerable<Book>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken)
        {
            return await DbSet.AsNoTracking().Where(c=>c.AuthorID==authorId).ToListAsync(cancellationToken);
        }

        public List<Book> GetExceptById(int id)
        {
            return DbSet.Where(c=>c.Id!=id).ToList();
        }

        public override async Task<PagedList<Book>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {

            if (searchObject.Descending)
            {
                return await DbSet.Include(c => c.UserRate).Include(c => c.CoverPhoto).Include(c => c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c => searchObject.AuthorName == null || c.Author.FullName.ToLower().Contains(searchObject.AuthorName.ToLower()))
                .Where(c => searchObject.isActive == null || c.isActive == searchObject.isActive)
                .OrderByDescending(c => c.OpeningCount)
               .ToPagedListAsync(searchObject, cancellationToken);
            }
            else
            {
                return await DbSet.Include(c => c.UserRate).Include(c => c.CoverPhoto).Include(c => c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c => searchObject.AuthorName == null || c.Author.FullName.ToLower().Contains(searchObject.AuthorName.ToLower()))
                .Where(c => searchObject.isActive == null || c.isActive == searchObject.isActive)
               .ToPagedListAsync(searchObject, cancellationToken);
            }
            
        }

       
    }
}
