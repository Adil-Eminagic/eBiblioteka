using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class BooksController : BaseCrudController<BookDto, BookUpsertDto, BooksSearchObject, IBooksService>
    {
        public BooksController(IBooksService service, ILogger<BooksController> logger) : base(service, logger)
        {
        }
        
    }
}
