using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class QuestionsController : BaseCrudController<QuestionDto, QuestionUpsertDto, QuestionsSearchObject, IQuestionsService>
    {
        public QuestionsController(IQuestionsService service, ILogger<QuestionsController> logger) : base(service, logger)
        {
        }
        
    }
}
