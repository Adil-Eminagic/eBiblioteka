namespace eBiblioteka.Core
{
    public class UserDto : BaseDto
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public DateTime? LastSignInAt { get; set; }
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }
        public bool IsActive { get; set; }

        public DateTime? PurchaseDate { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public bool IsActiveMembership { get; set; }

        public int? ProfilePhotoId { get; set; }
        public PhotoDto? ProfilePhoto { get; set; }

        public int CountryId { get; set; }
        public CountryDto Country { get; set; } = null!;

        public int GenderId { get; set; }
        public GenderDto Gender { get; set; } = null!;

        public int RoleId { get; set; }
        public RoleDto Role { get; set; } = null!;
    }
}
