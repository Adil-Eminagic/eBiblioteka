using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IBookGenresService : IBaseService<int, BookGenreDto, BookGenreUpsertDto, BaseSearchObject>
    {
    }
}
