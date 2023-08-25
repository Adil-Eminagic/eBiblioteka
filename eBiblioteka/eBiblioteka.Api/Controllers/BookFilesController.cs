using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using Microsoft.AspNetCore.Authorization;

namespace eBiblioteka.Api.Controllers
{
    public class BookFilesController : BaseCrudController<BookFileDto, BookFileUpsertDto, BaseSearchObject, IBookFilesService>
    {
        public BookFilesController(IBookFilesService service, ILogger<BookFilesController> logger) : base(service, logger)
        {
        }

        private async Task<byte[]>  Converter(string s)
        {
            return  Convert.FromBase64String(s);
        }
        
        public override async Task<IActionResult> Get(int id, CancellationToken cancellationToken = default)
        {
            try
            {

                var dto = await Service.GetByIdAsync(id, cancellationToken);
                byte[] bytes = await Converter(dto.Data);
                MemoryStream ms = new MemoryStream(bytes);
                return new FileStreamResult(ms, "application/pdf");
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting resource with ID {0}", id);
                return BadRequest(e.Message + " " + e?.InnerException);
            }
        }

    }
}


