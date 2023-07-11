using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class BookGenresController : BaseCrudController<BookGenreDto, BookGenreUpsertDto, BookGenresSearchObject, IBookGenresService>
    {
        public BookGenresController(IBookGenresService service, ILogger<BookGenresController> logger) : base(service, logger)
        {
        }
        
    }
}
