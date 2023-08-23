
using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class ReportInfoProfile:BaseProfile
    {
        public ReportInfoProfile()
        {
            CreateMap(typeof(ReportInfo<>), typeof(ReportInfo<>));
        }
    }
}
