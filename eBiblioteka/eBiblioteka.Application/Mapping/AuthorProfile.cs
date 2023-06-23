using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class AuthorProfile : BaseProfile
    {
        public AuthorProfile()
        {
            CreateMap<AuthorDto, Author>().ReverseMap();

            CreateMap<AuthorUpsertDto, Author>();
        }
    }
}
