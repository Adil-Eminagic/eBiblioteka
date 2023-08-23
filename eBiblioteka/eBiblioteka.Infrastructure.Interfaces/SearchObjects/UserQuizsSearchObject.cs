
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class UserQuizsSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? QuizId { get; set; }
    }
}
