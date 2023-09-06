using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class AuthorsService : BaseService<Author, AuthorDto, AuthorUpsertDto, AuthorsSearchObject, IAuthorsRepository>, IAuthorsService
    {
        private readonly IPhotosService _photosService;
        private readonly IRecommendResultsService _recommendResultsService;

        public AuthorsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<AuthorUpsertDto> validator, IPhotosService photosService, IRecommendResultsService recommendResultsService) : base(mapper, unitOfWork, validator)
        {
            _photosService = photosService;
            _recommendResultsService = recommendResultsService;
        }

        public async override Task<AuthorDto> AddAsync(AuthorUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Author>(dto);
            if (dto.Image != null)
            {//if image isn' null then it adds photo with photo service and add foreign key of that photo to author
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.Image;
                var photo = await _photosService.AddAsync(photoUpsertDto);
                entity.PhotoId = photo.Id;
            }

            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<AuthorDto>(entity);
        }

        public async override Task<AuthorDto> UpdateAsync(AuthorUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var author = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);// uvjeka await koristiti

            if (author == null)
                throw new Exception("Author not found.");

            var exsistringAuthorPhotoId = author.PhotoId ?? 0;//if user has photo, we put id of photo in variable

            Mapper.Map(dto, author);//we map all we can from dto to author

            if (dto.Image == null && exsistringAuthorPhotoId > 0)// ne može se null proslijediti 0
            {
                author.PhotoId = exsistringAuthorPhotoId;
            }
            else if (dto.Image != null)
            {
                if (exsistringAuthorPhotoId > 0)//if author have photo, update that photo
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringAuthorPhotoId, Data = dto.Image };
                    var photo = await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {//else add photo
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.Image };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    author.PhotoId = photo.Id;
                }
            }

            CurrentRepository.Update(author);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<AuthorDto>(author);
        }

        public async override Task RemoveByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            await CurrentRepository.RemoveByIdAsync(id, false, cancellationToken);

            await UnitOfWork.SaveChangesAsync(cancellationToken);
        }

    }
}
