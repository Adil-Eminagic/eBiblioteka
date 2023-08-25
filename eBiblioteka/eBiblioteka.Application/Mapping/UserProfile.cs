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
                .ForMember(u=>u.ProfilePhoto , o=>o.Ignore());//because it will be menaged by photo service and repository
             
        }
    }
}
