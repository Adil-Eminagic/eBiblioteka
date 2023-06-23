
namespace eBiblioteka.Core
{
     public class City : BaseEntity
    {
        public string Name { get; set; } = null!;
        public string ZipCode { get; set; } = null!;
        public bool IsActive { get; set; }

        public int CountryId { get; set; }
        public Country Country { get; set; } = null!;

       
    }
}
