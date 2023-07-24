
namespace eBiblioteka.Core
{
    public class AnswerUpsertDto : BaseUpsertDto
    {
        public string Content { get; set; } = null!;
        public bool IsTrue { get; set; }

        public int QuestionId { get; set; }

    }
}
