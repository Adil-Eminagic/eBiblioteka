using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface ICountriesService : IBaseService<int, CountryDto, CountryUpsertDto, CountrySearchObject>
    {

    }
}
