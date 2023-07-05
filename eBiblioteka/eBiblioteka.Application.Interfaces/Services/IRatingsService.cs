using eBiblioteka.Core;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application.Interfaces
{
    public interface IRatingsService : IBaseService<int, RatingDto, RatingUpsertDto, RatingsSearchObject>
    {
    }
}
