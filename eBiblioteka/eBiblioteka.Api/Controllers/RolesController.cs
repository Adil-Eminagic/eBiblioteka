using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class RolesController : BaseCrudController<RoleDto, RoleUpsertDto, BaseSearchObject, IRolesService>
    {
        public RolesController(IRolesService service, ILogger<RolesController> logger) : base(service, logger)
        {
        }
        
    }
}
