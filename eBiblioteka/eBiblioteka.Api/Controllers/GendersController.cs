using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class GendersController : BaseCrudController<GenderDto, GenderUpsertDto, BaseSearchObject, IGendersService>
    {
        public GendersController(IGendersService service, ILogger<GendersController> logger) : base(service, logger)
        {
        }

        [AllowAnonymous] // excludes autorization in inherited class
        public override Task<IActionResult> GetPaged([FromQuery] BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetPaged(searchObject, cancellationToken);
        }

    }
}
