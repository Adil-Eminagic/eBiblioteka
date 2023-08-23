
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Infrastructure
{
    public class CountriesRepository : BaseRepository<Country, int, CountrySearchObject>, ICountriesRepository
    {
        public CountriesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async override Task<PagedList<Country>> GetPagedAsync(CountrySearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.Name == null
             || c.Name.ToLower().Contains(searchObject.Name.ToLower()))
                 .Where(c => searchObject.Abbreviation == null ||
                 c.Abbreviation.ToLower().Contains(searchObject.Abbreviation.ToLower()))
                 .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async override Task<ReportInfo<Country>> GetCountAsync(CountrySearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.Name == null
            || c.Name.ToLower().Contains(searchObject.Name.ToLower()))
                .Where(c => searchObject.Abbreviation == null ||
                c.Abbreviation.ToLower().Contains(searchObject.Abbreviation.ToLower()))
                .ToReportInfoAsync(searchObject, cancellationToken);
        }
    }
}
