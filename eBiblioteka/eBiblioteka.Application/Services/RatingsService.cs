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

        
        public async Task<double> GetBookAverageRatingAsync(int bookId, CancellationToken cancellationToken = default)
        {

            try
            {
                var average = await CurrentRepository.GetBookAverageRatingAsync(bookId, cancellationToken);
                return average;
            }
            catch (Exception)
            {

                throw new Exception("Error getting book rates");
            }
        }

       

        public override async Task<RatingDto> AddAsync(RatingUpsertDto dto, CancellationToken cancellationToken = default)
        {
            if (dto.Stars < 1 || dto.Stars > 5 )
                throw new Exception("Rating stars cann't be greater than 5 or lower than 1.");

            var entities = await CurrentRepository.GetPagedAsync(new RatingsSearchObject() { BookId = dto.BookId, UserId = dto.UserId }, cancellationToken);

            if(entities.TotalCount >0)
                throw new Exception("You have already added rating. You cann't add multiple ratings.");

            return await base.AddAsync(dto, cancellationToken);
        }
    }
}
