using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public class UsersRepository : BaseRepository<User, int, UsersSearchObject>, IUsersRepository
    {
        public UsersRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<User?> ChangeEmailAsync(int userId, JsonPatchDocument jsonPatch, CancellationToken cancellationToken=default)
        {
            var user = await DbSet.FindAsync(userId);
            if (user != null)
            {
                jsonPatch.ApplyTo(user);
                return user;
            }
            return null;
        }

        public async Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.Role).AsNoTracking().FirstOrDefaultAsync(x => x.Email == email, cancellationToken);
        }


        public override async Task<PagedList<User>> GetPagedAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c=>c.ProfilePhoto).Include(c=>c.Role).Include(c=>c.Gender).Where(c => searchObject.FullName == null || c.FirstName.ToLower().Contains(searchObject.FullName.ToLower())
            || c.LastName.ToLower().Contains(searchObject.FullName.ToLower())).
            Where(c=> searchObject.RoleName==null || searchObject.RoleName==c.Role.Value)
            .Where(c=>searchObject.IsActive== null || c.IsActive==searchObject.IsActive)
            .ToPagedListAsync(searchObject, cancellationToken);
        }

        public List<User> UsersWithReadHistory()//this is for recommend system to get all books' history of all users
        {
            return DbSet.Include(c => c.OpenedBooks).Where(s=>s.RoleId==3).ToList();
        }

        public async override Task<ReportInfo<User>> GetCountAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.Role).Include(c => c.Gender).Where(c => searchObject.FullName == null || c.FirstName.ToLower().Contains(searchObject.FullName.ToLower())
            || c.LastName.ToLower().Contains(searchObject.FullName.ToLower())).
            Where(c => searchObject.RoleName == null || searchObject.RoleName == c.Role.Value)
            .Where(c => searchObject.IsActive == null || c.IsActive == searchObject.IsActive)
            .ToReportInfoAsync(searchObject, cancellationToken);
        }
    }
}
