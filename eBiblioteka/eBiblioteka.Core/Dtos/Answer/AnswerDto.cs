
namespace eBiblioteka.Core
{
    public class AnswerDto:BaseDto
    {
        public string Content { get; set; } = null!;
        public bool IsTrue { get; set; }

        public int QuestionId { get; set; }
        public QuestionDto Question { get; set; } = null!;
    }
}
