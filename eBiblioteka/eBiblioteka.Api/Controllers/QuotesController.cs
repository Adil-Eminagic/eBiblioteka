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
    }
}
