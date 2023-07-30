using eBiblioteka.Core;
using eBiblioteka.Core.Dtos.User;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.AspNetCore.JsonPatch;

namespace eBiblioteka.Application.Interfaces
{
    public interface IUsersService : IBaseService<int, UserDto, UserUpsertDto, UsersSearchObject>
    {
        Task<UserSensitiveDto?> GetByEmailAsync(string email, CancellationToken cancellationToken = default);
        Task<UserDto> ChangeEmailAsync(int userId, JsonPatchDocument jsonPatch, CancellationToken cancellationToken= default);
        Task ChangePasswordAsync(UserChangePasswordDto dto, CancellationToken cancellationToken=default);
        List<UserHisoryDto> UsersWithReadHistory();
        Task<UserDto> DeactivateAsync(int userId, CancellationToken cancellationToken=default);
        Task<UserDto> ActivateAsync(int userId, CancellationToken cancellationToken = default);


    }
}
