using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface ICitiesService : IBaseService<int, CityDto, CityUpsertDto, CitiesSearchObject>
    {
        Task<IEnumerable<CityDto>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default);
    }
}
