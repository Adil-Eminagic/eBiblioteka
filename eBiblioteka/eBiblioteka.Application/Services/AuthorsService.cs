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

        public AuthorsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<AuthorUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
            _photosService = photosService;
        }

        public async override Task<AuthorDto> AddAsync(AuthorUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Author>(dto);
            if (dto.image != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.image;
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

            var exsistringAuthorPhotoId = author.PhotoId ?? 0;

            Mapper.Map(dto, author);

            if (dto.image == null && exsistringAuthorPhotoId > 0)// ne može se null dodsjeliti 0
            {
                author.PhotoId = exsistringAuthorPhotoId;
            }
            else if (dto.image != null)
            {
                if (exsistringAuthorPhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringAuthorPhotoId, Data = dto.image };
                    var photo = await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.image };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    author.PhotoId = photo.Id;
                }
            }

            CurrentRepository.Update(author);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<AuthorDto>(author);
        }

    }
}
