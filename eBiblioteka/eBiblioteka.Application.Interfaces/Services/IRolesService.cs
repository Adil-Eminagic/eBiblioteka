using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IRolesService : IBaseService<int, RoleDto, RoleUpsertDto, BaseSearchObject>
    {
    }
}
