using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class BooksController : BaseCrudController<BookDto, BookUpsertDto, BooksSearchObject, IBooksService>
    {
       

        public BooksController(IBooksService service, ILogger<BooksController> logger) : base(service, logger)
        {
           
         
        }

        [Authorize]
        [HttpPut("OpenBook/{bookId}")]
        public virtual async Task<IActionResult> OpenBook(int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var books = await Service.OpenBookAsync(bookId,cancellationToken);
                return Ok(books);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error ", bookId);
                return BadRequest();
            }
        }


        [Authorize]
        [HttpGet("DoesExist/{bookId}")]
        public virtual async Task<IActionResult> DoesExist(int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var exist = await Service.DoesExist(bookId, cancellationToken);
                return Ok(exist);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error ", bookId);
                return BadRequest();
            }
        }



    }
}
