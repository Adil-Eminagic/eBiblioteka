
namespace eBiblioteka.Infrastructure.Interfaces
{
    public class CitiesSearchObject : BaseSearchObject
    {
        public int? CountryId { get; set; }
        public string? Name { get; set; }
    }
}
