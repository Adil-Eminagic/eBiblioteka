
namespace eBiblioteka.Core
{
    public class Question : BaseEntity
    {
        public string Content { get; set; } = null!;
        public int Points { get; set; }

        public int QuizId { get; set; }
        public Quiz Quiz { get; set; } = null!;

        public ICollection<Answer> Answers { get; set; } = null!;

    }
}
