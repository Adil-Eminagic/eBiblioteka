
namespace eBiblioteka.Core
{
    public class Answer:BaseEntity
    {
        public string Content { get; set; } = null!;
        public bool IsTrue { get; set; }

        public int QuestionId { get; set; }
        public Question Question { get; set; }=null!;
    }
}
