using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class CountriesController : BaseCrudController<CountryDto, CountryUpsertDto, CountrySearchObject, ICountriesService>
    {
        public CountriesController(ICountriesService service, ILogger<CountriesController> logger) : base(service, logger)
        {
        }

        [AllowAnonymous]
        public override Task<IActionResult> GetPaged([FromQuery] CountrySearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetPaged(searchObject, cancellationToken);
        }
    }
}
