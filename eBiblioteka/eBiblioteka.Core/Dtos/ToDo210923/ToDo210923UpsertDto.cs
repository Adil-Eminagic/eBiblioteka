
namespace eBiblioteka.Core
{
    public class ToDo210923UpsertDto:BaseUpsertDto
    {
        public string ActivityName { get; set; } = null!;
        public string ActivityDescription { get; set; } = null!;
        public DateTime FinshingDate { get; set; }
        public string StatusCode { get; set; } = null!;

        public int UserId { get; set; }
    }
}
