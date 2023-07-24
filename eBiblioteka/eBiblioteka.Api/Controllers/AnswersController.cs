using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class AnswersController : BaseCrudController<AnswerDto, AnswerUpsertDto, AnswersSearchObject, IAnswersService>
    {
        public AnswersController(IAnswersService service, ILogger<AnswersController> logger) : base(service, logger)
        {
        }
        
    }
}
