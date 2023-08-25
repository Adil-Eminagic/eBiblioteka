
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
           return DbSet.ToList();
        }


        public override async Task<Book?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.UserRate).FirstOrDefaultAsync(c => c.Id == id, cancellationToken);
        }


        public List<Book> GetExceptById(int id)// this is needed for recommendatio sytem to do make all combinations od specific book and all other books 
        {
            return DbSet.Where(c=>c.Id!=id).ToList();
        }

        public override async Task<PagedList<Book>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {

            if (searchObject.Descending)//descending is needed for home page in mobile app where are most read books showed
            {
                return await DbSet.Include(c => c.UserRate).Include(c => c.CoverPhoto).Include(c => c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c => searchObject.AuthorName == null || c.Author.FullName.ToLower().Contains(searchObject.AuthorName.ToLower()))
                .OrderByDescending(c => c.OpeningCount)
               .ToPagedListAsync(searchObject, cancellationToken);
            }
            else
            {
                return await DbSet.Include(c => c.UserRate).Include(c => c.CoverPhoto).Include(c => c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c => searchObject.AuthorName == null || c.Author.FullName.ToLower().Contains(searchObject.AuthorName.ToLower()))
               .ToPagedListAsync(searchObject, cancellationToken);
            }
        }

        public async override Task<ReportInfo<Book>> GetCountAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.UserRate).Include(c => c.Author).Where(c => searchObject.Title == null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Where(c => searchObject.AuthorName == null || c.Author.FullName.ToLower().Contains(searchObject.AuthorName.ToLower()))
               .ToReportInfoAsync(searchObject, cancellationToken);
        }
            
            
    }
}
