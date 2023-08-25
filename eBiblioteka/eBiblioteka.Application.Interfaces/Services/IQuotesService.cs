using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IQuotesService : IBaseService<int, QuoteDto, QuoteUpsertDto, QuotesSearchObject>
    {
    }
}
