using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Api.Controllers
{
    public class ToDo210923sController : BaseCrudController<ToDo210923Dto, ToDo210923UpsertDto, ToDo210923sSearchObject, IToDo210923sService>
    {
        public ToDo210923sController(IToDo210923sService service, ILogger<ToDo210923sController> logger) : base(service, logger)
        {
        }
        
    }
}
