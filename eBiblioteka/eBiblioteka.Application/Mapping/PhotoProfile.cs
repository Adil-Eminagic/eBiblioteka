using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class PhotoProfile : BaseProfile
    {
        public PhotoProfile()
        {
            CreateMap<PhotoDto, Photo>().ReverseMap();

            CreateMap<PhotoUpsertDto, Photo>();
        }
    }
}
