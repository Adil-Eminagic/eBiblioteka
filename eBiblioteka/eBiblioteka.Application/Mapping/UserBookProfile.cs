using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserBookProfile : BaseProfile
    {
        public UserBookProfile()
        {
            CreateMap<UserBookDto, UserBook>().ReverseMap();

            CreateMap<UserBookUpsertDto, UserBook>();
        }
    }
}
