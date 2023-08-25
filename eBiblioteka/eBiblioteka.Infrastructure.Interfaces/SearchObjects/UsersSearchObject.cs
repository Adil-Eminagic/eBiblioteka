
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class UsersSearchObject : BaseSearchObject
    {
        public string? FullName { get; set; }
        public string? RoleName { get; set; }
        public bool? IsActive { get; set; }


    }
}
