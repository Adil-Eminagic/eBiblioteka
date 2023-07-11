namespace eBiblioteka.Api
{
    public class AccessSignUpModel
    {
        public string FirstName { get; set; } = null!;
        public string LastName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public string PhoneNumber { get; set; } = null!;
        public string Password { get; set; } = null!;
        public int CountryId { get; set; }
        public int GenderId { get; set; }

    }
}
