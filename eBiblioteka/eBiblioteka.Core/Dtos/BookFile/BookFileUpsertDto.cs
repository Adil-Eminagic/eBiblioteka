
namespace eBiblioteka.Core
{
    public class BookFileUpsertDto:BaseUpsertDto
    {
        public string Name { get; set; } = null!;

        public string Data { get; set; } = null!;
    }
}
