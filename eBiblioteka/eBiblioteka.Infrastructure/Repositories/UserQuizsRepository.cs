using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class UserQuizsRepository : BaseRepository<UserQuiz, int, UserQuizsSearchObject>, IUserQuizsRepository
    {
        public UserQuizsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }


        public override async Task<PagedList<UserQuiz>> GetPagedAsync(UserQuizsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.Quiz).Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
           Where(c => searchObject.QuizId == null || searchObject.QuizId == c.QuizId)
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<UserQuiz>> GetCountAsync(UserQuizsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.UserId == null || c.UserId == searchObject.UserId).
            Where(c => searchObject.QuizId == null || searchObject.QuizId == c.QuizId).
             ToReportInfoAsync(searchObject, cancellationToken);
        }
    }
}
