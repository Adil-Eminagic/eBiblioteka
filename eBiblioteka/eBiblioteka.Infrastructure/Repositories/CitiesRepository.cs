
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class CitiesRepository : BaseRepository<City, int, CitiesSearchObject>, ICitiesRepository
    {
        public CitiesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<IEnumerable<City>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c => c.CountryId == countryId).ToListAsync(cancellationToken);
        }

        public override async Task<PagedList<City>> GetPagedAsync(CitiesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.Country).Where(c => searchObject.Name == null || c.Name.ToLower().Contains(searchObject.Name.ToLower()))
                .Where(c => searchObject.CountryId == null || c.CountryId == searchObject.CountryId)
               .ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
