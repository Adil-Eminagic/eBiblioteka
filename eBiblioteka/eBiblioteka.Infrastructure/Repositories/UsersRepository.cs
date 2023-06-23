using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class UsersRepository : BaseRepository<User, int, UsersSearchObject>, IUsersRepository
    {
        public UsersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().FirstOrDefaultAsync(x => x.Email == email, cancellationToken);
        }

        public override async Task<PagedList<User>> GetPagedAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.FullName == null || c.FirstName.ToLower().Contains(searchObject.FullName.ToLower())
            || c.LastName.ToLower().Contains(searchObject.FullName.ToLower())).ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
