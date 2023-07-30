using eBiblioteka.Core;
using eBiblioteka.Core.Dtos.User;

namespace eBiblioteka.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<UserDto, User>().ReverseMap();

            CreateMap<User, UserSensitiveDto>();

            CreateMap<User, UserHisoryDto>().ReverseMap();

            CreateMap<UserDto, UserUpsertDto>();

            CreateMap<UserUpsertDto, User>()
                .ForMember(u=>u.ProfilePhoto , o=>o.Ignore());
             
        }
    }
}
