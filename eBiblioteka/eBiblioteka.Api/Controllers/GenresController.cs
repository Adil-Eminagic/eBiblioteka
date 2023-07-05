using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class GenresController : BaseCrudController<GenreDto, GenreUpsertDto, GenresSearchObject, IGenresService>
    {
        public GenresController(IGenresService service, ILogger<GenresController> logger) : base(service, logger)
        {
        }

        [AllowAnonymous] // exclides autorization in inherited class
        public override Task<IActionResult> GetPaged([FromQuery] GenresSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetPaged(searchObject, cancellationToken);
        }

    }
}
