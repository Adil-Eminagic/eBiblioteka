using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class UsersController : BaseCrudController<UserDto, UserUpsertDto, UsersSearchObject, IUsersService>
    {
        public UsersController(IUsersService service, ILogger<UsersController> logger) : base(service, logger)
        {
        }
        
    }
}
