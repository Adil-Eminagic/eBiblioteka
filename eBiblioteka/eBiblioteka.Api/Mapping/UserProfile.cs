using eBiblioteka.Api;
using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<AccessSignUpModel, UserUpsertDto>()
                .ForMember(a => a.RoleId, o => o.MapFrom(s => 3));
        }
    }
}
