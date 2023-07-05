using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IGendersService : IBaseService<int, GenderDto, GenderUpsertDto, BaseSearchObject>
    {
    }
}
