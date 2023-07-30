using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class UserBooksController : BaseCrudController<UserBookDto, UserBookUpsertDto, UserBooksSearchObject, IUserBooksService>
    {
        public UserBooksController(IUserBooksService service, ILogger<UserBooksController> logger) : base(service, logger)
        {
        }
        
    }
}
