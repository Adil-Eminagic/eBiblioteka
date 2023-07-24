
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class QuestionsSearchObject : BaseSearchObject
    {
        public string? Content { get; set; }
        public int? Points { get; set; }
        public int? QuizId { get; set; }

    }
}
