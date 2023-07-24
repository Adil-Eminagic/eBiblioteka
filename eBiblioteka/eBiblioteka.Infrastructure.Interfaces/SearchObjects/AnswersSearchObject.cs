
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class AnswersSearchObject : BaseSearchObject
    {
        public string? Content { get; set; }
        public bool? IsTrue { get; set; }
        public int? QuestionId { get; set; }

    }
}
