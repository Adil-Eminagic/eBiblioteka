using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class RatingsController : BaseCrudController<RatingDto, RatingUpsertDto, RatingsSearchObject, IRatingsService>
    {
        public RatingsController(IRatingsService service, ILogger<RatingsController> logger) : base(service, logger)
        {
        }

        [Authorize]
        [HttpGet("BookAverageRate/{bookId}")]
        public async Task<IActionResult> GetBookAverageRating(int bookId, CancellationToken cancellation=default)
        {
            try
            {
                var rate = await Service.GetBookAverageRatingAsync(bookId, cancellation);
                return Ok(rate);
            }
            catch (Exception)
            {

                throw new Exception("Error getting book rates");
            }
        }
       
        
    }
}
