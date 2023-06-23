namespace eBiblioteka.Core
{
    public class GenreUpsertDto : BaseUpsertDto
    {
        public string Name { get; set; } = null!;
        public string Abbreviation { get; set; } = null!;
    }
}
