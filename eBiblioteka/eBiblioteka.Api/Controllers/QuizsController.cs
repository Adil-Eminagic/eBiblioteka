using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class QuizsController : BaseCrudController<QuizDto, QuizUpsertDto, QuizzesSearchObject, IQuizsService>
    {
        public QuizsController(IQuizsService service, ILogger<QuizsController> logger) : base(service, logger)
        {
        }
        
    }
}
