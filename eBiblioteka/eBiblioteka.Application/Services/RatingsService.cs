using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class RatingsService : BaseService<Rating, RatingDto, RatingUpsertDto, RatingsSearchObject, IRatingsRepository>, IRatingsService
    {
        public RatingsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<RatingUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
