using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class ToDo210923Profile : BaseProfile
    {
        public ToDo210923Profile()
        {
            CreateMap<ToDo210923Dto, ToDo210923>().ReverseMap();

            CreateMap<ToDo210923UpsertDto, ToDo210923>();
        }
    }
}
