namespace eBiblioteka.Core
{
    public class UserDto : BaseDto
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public Role Role { get; set; }
        public DateTime? LastSignInAt { get; set; }
        public Gender Gender { get; set; }
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }

        public int? ProfilePhotoId { get; set; }
        public PhotoDto? ProfilePhoto { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;
    }
}
