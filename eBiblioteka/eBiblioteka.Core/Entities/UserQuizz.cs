

namespace eBiblioteka.Core
{
    public class UserQuiz : BaseEntity
    {
        public int QuizId { get; set; }
        public Quiz Quiz { get; set; } = null!;

        public int UserId { get; set; }
        public User User { get; set; } = null!;

        public double Percentage { get; set; }


    }
}
