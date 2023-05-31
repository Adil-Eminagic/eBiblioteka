using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class QuotesController : BaseCrudController<QuoteDto, QuoteUpsertDto, QuotesSearchObject, IQuotesService>
    {
        public QuotesController(IQuotesService service, ILogger<QuotesController> logger) : base(service, logger)
        {
        }

        [HttpGet("ByBook")]
        public async Task<IActionResult> GetByBook([FromQuery] int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var Quotes = await Service.GetByBookAsync(bookId, cancellationToken);
                return Ok(Quotes);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while getting Quotes by book ID {0}", bookId);
                return BadRequest();
            }
        }
    }
}
