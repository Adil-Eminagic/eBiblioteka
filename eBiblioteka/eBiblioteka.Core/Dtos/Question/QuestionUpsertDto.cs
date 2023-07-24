
namespace eBiblioteka.Core
{
    public class QuestionUpsertDto:BaseUpsertDto
    {
        public string Content { get; set; } = null!;
        public int Points { get; set; }

        public int QuizId { get; set; }
    }
}
