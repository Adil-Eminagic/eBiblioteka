using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class CitiesController : BaseCrudController<CityDto, CityUpsertDto, CitiesSearchObject, ICitiesService>
    {
        public CitiesController(ICitiesService service, ILogger<CitiesController> logger) : base(service, logger)
        {
        }

        [HttpGet("ByCountry")]
        public async Task<IActionResult> GetByCountry([FromQuery] int countryId, CancellationToken cancellationToken = default)
        {
            try
            {
                var cities = await Service.GetByCountryIdAsync(countryId, cancellationToken);
                return Ok(cities);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while getting cities by country ID {0}", countryId);
                return BadRequest();
            }
        }
    }
}
