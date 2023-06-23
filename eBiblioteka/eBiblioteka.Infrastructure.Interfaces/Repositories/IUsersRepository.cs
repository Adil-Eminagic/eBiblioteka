
using eBiblioteka.Core;

namespace eBiblioteka.Infrastructure.Interfaces
{
    public interface IUsersRepository : IBaseRepository<User, int, UsersSearchObject>
    {
        Task<User?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
    }
}
