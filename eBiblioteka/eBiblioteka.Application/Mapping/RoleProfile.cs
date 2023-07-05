using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RoleProfile : BaseProfile
    {
        public RoleProfile()
        {
            CreateMap<RoleDto, Role>().ReverseMap();

            CreateMap<RoleUpsertDto, Role>();
        }
    }
}
