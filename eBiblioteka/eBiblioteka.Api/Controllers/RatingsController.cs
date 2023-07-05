using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class RatingsController : BaseCrudController<RatingDto, RatingUpsertDto, RatingsSearchObject, IRatingsService>
    {
        public RatingsController(IRatingsService service, ILogger<RatingsController> logger) : base(service, logger)
        {
        }
        
    }
}
