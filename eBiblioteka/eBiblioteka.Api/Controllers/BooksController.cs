using Microsoft.AspNetCore.Mvc;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.ML;
using Microsoft.AspNetCore.Authorization;
using System.Net;

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
        [HttpGet("GetByAuthorId/{authorId}")]
        public virtual async Task<IActionResult > GetByAuthorId(int authorId , CancellationToken cancellationToken = default)
        {
            try
            {
                var books = await Service.GetByAuthorIdAsync(authorId, cancellationToken);
                return Ok(books);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while getting book by book ID {0}", authorId);
                return BadRequest();
            }
        }

        [Authorize]
        [HttpPost("OpenBook/{bookId}")]
        public virtual async Task<IActionResult> OpenBook(int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var books = await Service.OpenBookAsync(bookId,cancellationToken);
                return Ok(books);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Error while getting book by book ID {0}", bookId);
                return BadRequest();
            }
        }

        [Authorize]
        [HttpPut("Deactivate")]
        public async Task<IActionResult> Deactivate([FromQuery] int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.DeactivateAsync(bookId, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {

                Logger.LogError(e, "Problem when updating password");
                return BadRequest(e.Message + ", " + e?.InnerException);
            }
        }

        [Authorize]
        [HttpPut("Activate")]
        public async Task<IActionResult> Activate([FromQuery] int bookId, CancellationToken cancellationToken = default)
        {
            try
            {
                var dto = await Service.ActivateAsync(bookId, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {

                Logger.LogError(e, "Problem when updating password");
                return BadRequest(e.Message + ", " + e?.InnerException);
            }
        }

        ////[Authorize]
        //[HttpGet("Recommend")]
        //public ActionResult Recommend(int bookId, CancellationToken cancellationToken = default)
        //{
        //    try
        //    {
        //        var books = Service.Recommend(bookId);
        //        return Ok(books);
        //    }
        //    catch (Exception e)
        //    {
        //        Logger.LogError(e, "Error while getting book by book ID {0}", bookId);
        //        return BadRequest();
        //    }
        //}

        //[HttpGet("Train")]
        //public async Task<ActionResult> Train( CancellationToken cancellationToken = default)
        //{
        //    try
        //    {
        //        var result = await Service.TrainBooksModel( cancellationToken);
        //        return Ok(result);
        //    }
        //    catch (Exception e)
        //    {
        //        Logger.LogError(e, "Error while getting book by book ID {0}");
        //        return BadRequest();
        //    }
        //}
    }
}
