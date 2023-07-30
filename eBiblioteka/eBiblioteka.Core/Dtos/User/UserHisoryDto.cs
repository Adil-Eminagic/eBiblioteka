
namespace eBiblioteka.Core.Dtos.User
{
    public class UserHisoryDto : UserDto
    {
        public ICollection<UserBook> OpenedBooks { get; set; } = null!;
    }
}
