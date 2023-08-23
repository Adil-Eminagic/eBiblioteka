
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class AnswersRepository : BaseRepository<Answer, int, AnswersSearchObject>, IAnswersRepository
    {
        public AnswersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Answer>> GetPagedAsync(AnswersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(c=> searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c=> searchObject.IsTrue==null || c.IsTrue==searchObject.IsTrue)
                .Where(c=> searchObject.QuestionId==c.QuestionId || searchObject.QuestionId==null)    
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<Answer>> GetCountAsync(AnswersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return   await DbSet
                .Where(c => searchObject.Content == null || c.Content.ToLower().Contains(searchObject.Content.ToLower()))
                .Where(c => searchObject.IsTrue == null || c.IsTrue == searchObject.IsTrue)
                .Where(c => searchObject.QuestionId == c.QuestionId || searchObject.QuestionId == null)
            .ToReportInfoAsync(searchObject, cancellationToken);
        }

        


    }
}
