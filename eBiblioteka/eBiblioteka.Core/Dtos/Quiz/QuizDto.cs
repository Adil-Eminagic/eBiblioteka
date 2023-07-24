
namespace eBiblioteka.Core
{
    public class QuizDto:BaseDto
    {
        public string Title { get; set; } = null!;
        public string? Description { get; set; }
        public bool isActive { get; set; }
        public int? TotalPoints { get; set; }

    }
}
