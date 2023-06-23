using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<UserDto, User>().ReverseMap();

            CreateMap<User, UserSensitiveDto>();

            CreateMap<UserDto, UserUpsertDto>();

            CreateMap<UserUpsertDto, User>()
               .ForMember(u => u.Role, o => o.Condition(s => s.Role != null));
        }
    }
}
