
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class QuizsRepository : BaseRepository<Quiz, int, QuizzesSearchObject>, IQuizsRepository
    {
        public QuizsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Quiz>> GetPagedAsync(QuizzesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c=>searchObject.Title== null || c.Title.ToLower().Contains(searchObject.Title.ToLower()))
                .Include(c=>c.Questions)
                .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
