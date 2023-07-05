using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.ML;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class BooksController : BaseCrudController<BookDto, BookUpsertDto, BooksSearchObject, IBooksService>
    {
       

        public BooksController(IBooksService service, ILogger<BooksController> logger) : base(service, logger)
        {
           
         
        }

        [HttpGet("GetRecomendedBooks")]
        public virtual async Task<IActionResult> GetRecomendedBooks(string[] authors)
        {
            //var userPreferences= new UserPreferences() {Authors=authors };
            throw new NotImplementedException();
        }

        [Authorize]
        [HttpGet("GetByAuthorId")]
        public virtual async Task<IActionResult > GetByAuthorId(int authorId , CancellationToken cancellationToken = default)
        {
            try
            {
                var books = await Service.GetByAuthorIdAsync(authorId, cancellationToken);
                return Ok(books);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while getting cities by country ID {0}", authorId);
                return BadRequest();
            }
        }
    }
}
