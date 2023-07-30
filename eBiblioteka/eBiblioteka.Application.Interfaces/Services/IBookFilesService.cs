using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IBookFilesService : IBaseService<int, BookFileDto, BookFileUpsertDto, BaseSearchObject>
    {
        
    }
}
