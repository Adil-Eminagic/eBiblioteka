using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class UserQuizsController : BaseCrudController<UserQuizDto, UserQuizUpsertDto, UserQuizsSearchObject, IUserQuizsService>
    {
        public UserQuizsController(IUserQuizsService service, ILogger<UserQuizsController> logger) : base(service, logger)
        {
        }
        
    }
}
