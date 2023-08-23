
namespace eBiblioteka.Core
{
    public class UserQuizDto:BaseDto
    {
        public int QuizId { get; set; }
        public QuizDto Quiz { get; set; } = null!;

        public int UserId { get; set; }
        public UserDto User { get; set; } = null!;

        public double Percentage { get; set; }
    }
}
