using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IGenresService : IBaseService<int, GenreDto, GenreUpsertDto, GenresSearchObject>
    {
    }
}
