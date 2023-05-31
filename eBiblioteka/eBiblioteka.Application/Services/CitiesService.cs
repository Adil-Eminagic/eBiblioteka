using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class CitiesService : BaseService<City, CityDto, CityUpsertDto, CitiesSearchObject, ICitiesRepository>, ICitiesService
    {
        public CitiesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CityUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public async Task<IEnumerable<CityDto>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
        {
            var cities = await CurrentRepository.GetByCountryIdAsync(countryId, cancellationToken);

            return Mapper.Map<IEnumerable<CityDto>>(cities);
        }
    }
}
