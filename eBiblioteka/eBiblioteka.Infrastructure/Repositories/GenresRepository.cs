
using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;


namespace eBiblioteka.Infrastructure
{
    public class GenresRepository : BaseRepository<Genre, int, GenresSearchObject>, IGenresRepository
    {
        public GenresRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Genre>> GetPagedAsync(GenresSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.Name == null || c.Name.ToLower().Contains(searchObject.Name.ToLower()))
               .ToPagedListAsync(searchObject, cancellationToken);
        }

       
    }
}
