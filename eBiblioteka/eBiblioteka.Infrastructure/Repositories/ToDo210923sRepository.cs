
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class ToDo210923sRepository : BaseRepository<ToDo210923, int, ToDo210923sSearchObject>, IToDo210923sRepository
    {
        public ToDo210923sRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<ToDo210923>> GetPagedAsync(ToDo210923sSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Include(c=>c.User)
                .Where(c=> searchObject.UserId == null || c.UserId==searchObject.UserId)
                .Where(c=> searchObject.FinishingDate == null || c.FinshingDate < searchObject.FinishingDate)
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<ToDo210923>> GetCountAsync(ToDo210923sSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                 .Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId)
                 .Where(c => searchObject.FinishingDate == null || c.FinshingDate < searchObject.FinishingDate)
             .ToReportInfoAsync(searchObject, cancellationToken);
        }

        


    }
}
