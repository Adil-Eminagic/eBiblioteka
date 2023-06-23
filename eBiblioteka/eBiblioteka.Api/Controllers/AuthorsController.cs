using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class AuthorsController : BaseCrudController<AuthorDto, AuthorUpsertDto, AuthorsSearchObject, IAuthorsService>
    {
        public AuthorsController(IAuthorsService service, ILogger<AuthorsController> logger) : base(service, logger)
        {
        }
        
    }
}
