
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class QuestionsRepository : BaseRepository<Question, int, QuestionsSearchObject>, IQuestionsRepository
    {
        public QuestionsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Question>> GetPagedAsync(QuestionsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.QuizId == null || c.QuizId==searchObject.QuizId)
                .Where(c=> searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c=> searchObject.Points==null || c.Points==searchObject.Points)
                .Include(c=>c.Answers)
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<Question>> GetCountAsync(QuestionsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.QuizId == null || c.QuizId == searchObject.QuizId)
                .Where(c => searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c => searchObject.Points == null || c.Points == searchObject.Points)
                .Include(c => c.Answers)
            .ToReportInfoAsync(searchObject, cancellationToken);
        }


    }
}
