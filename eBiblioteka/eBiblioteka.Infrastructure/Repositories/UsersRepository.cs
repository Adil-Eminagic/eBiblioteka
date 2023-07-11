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
            return await DbSet.Include(c=>c.Role).AsNoTracking().FirstOrDefaultAsync(x => x.Email == email, cancellationToken);
        }

        public async override Task<User?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.ProfilePhoto).FirstOrDefaultAsync(c=>c.Id==id,cancellationToken);
        }


        public override async Task<PagedList<User>> GetPagedAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.ProfilePhoto).Include(c=>c.Role).Include(c=>c.Gender).Where(c => searchObject.FullName == null || c.FirstName.ToLower().Contains(searchObject.FullName.ToLower())
            || c.LastName.ToLower().Contains(searchObject.FullName.ToLower())).
            Where(c=> searchObject.RoleName==null || searchObject.RoleName==c.Role.Value)
            .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
