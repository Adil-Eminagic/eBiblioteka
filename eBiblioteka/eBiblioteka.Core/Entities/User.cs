
using System.ComponentModel.DataAnnotations.Schema;

namespace eBiblioteka.Core
{
    public class User : BaseEntity
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public DateTime? LastSignInAt { get; set; }
        public string? Biography { get; set; }
        public DateTime BirthDate { get; set; }
        public bool IsActive { get; set; } = true;

        public DateTime? PurchaseDate { get; set; }
        public DateTime? ExpirationDate { get; set; }

        public bool IsActiveMembership { get; set; }

        public int? ProfilePhotoId { get; set; }
        public Photo? ProfilePhoto { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

        public int GenderId { get; set; }
        public Gender Gender { get; set; } = null!;

        public int RoleId { get; set; }
        public Role Role { get; set; } = null!;

        public ICollection<UserBook> OpenedBooks { get; set; } = null!;
        public ICollection<Rating> RateBook { get; set; } = null!;
        public ICollection<Notification> Notifications { get; set; }= null!;
        public ICollection<UserQuiz> Quizzes { get; set; } = null!;


    }
}
