
namespace eBiblioteka.Core
{
    public class Quiz:BaseEntity
    {
        public string Title { get; set; } = null!;
        public string? Description { get; set; }

        public ICollection<Question> Questions { get; set; }=null!;
        public ICollection<UserQuiz> Users { get; set; } = null!;
    }
}
