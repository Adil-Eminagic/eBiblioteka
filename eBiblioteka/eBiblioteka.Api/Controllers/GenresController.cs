using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class GenresController : BaseCrudController<GenreDto, GenreUpsertDto, GenresSearchObject, IGenresService>
    {
        public GenresController(IGenresService service, ILogger<GenresController> logger) : base(service, logger)
        {
        }
        
    }
}
