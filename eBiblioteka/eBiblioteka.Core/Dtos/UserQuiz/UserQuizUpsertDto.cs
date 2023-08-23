
namespace eBiblioteka.Core
{
    public class UserQuizUpsertDto:BaseUpsertDto
    {
        public int QuizId { get; set; }

        public int UserId { get; set; }

        public double Percentage { get; set; }

    }
}
