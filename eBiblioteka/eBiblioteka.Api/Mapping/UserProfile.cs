using eBiblioteka.Api;
using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserProfile : BaseProfile
    {
        public UserProfile()
        {
            CreateMap<AccessSignUpModel, UserUpsertDto>()
                .ForMember(a => a.Role, o => o.MapFrom(s => Role.User));

            //CreateMap<UserUpsertModel, UserUpsertDto>()
            //    .ForMember(a => a.ProfilePhoto, o => o.Ignore())
            //    .ForMember(a => a.Role, o => o.MapFrom(s => Role.User));

            //CreateMap<UserUpdateProfilePhotoModel, UserUpsertDto>();
        }
    }
}
