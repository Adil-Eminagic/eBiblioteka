using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IUsersService : IBaseService<int, UserDto, UserUpsertDto, UsersSearchObject>
    {
        Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);

    }
}
