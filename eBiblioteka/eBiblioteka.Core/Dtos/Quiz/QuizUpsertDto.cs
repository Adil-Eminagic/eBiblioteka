
namespace eBiblioteka.Core
{
    public class QuizUpsertDto:BaseUpsertDto
    {
        public string Title { get; set; } = null!;
        public string? Description { get; set; }

    }
}
