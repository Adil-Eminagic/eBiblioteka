using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class BooksService : BaseService<Book, BookDto, BookUpsertDto, BooksSearchObject, IBooksRepository>, IBooksService
    {
        private readonly IPhotosService _photosService;

        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
            this._photosService = photosService;
        }

        public async Task<IEnumerable<BookDto>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken)
        {
            var books = await CurrentRepository.GetByAuthorIdAsync(authorId, cancellationToken);
            return Mapper.Map<IEnumerable<BookDto>>(books);
        }

        public async override Task<BookDto> AddAsync(BookUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Book>(dto);
            if (dto.image != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.image;
                var photo = await _photosService.AddAsync(photoUpsertDto);
                entity.CoverPhotoId = photo.Id;
            }

            await CurrentRepository.AddAsync(entity, cancellationToken);
            await UnitOfWork.SaveChangesAsync(cancellationToken);
            return Mapper.Map<BookDto>(entity);
        }

        public async override Task<BookDto> UpdateAsync(BookUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var book = await CurrentRepository.GetByIdAsync(dto.Id.Value, cancellationToken);// uvjeka await koristiti

            if (book == null)
                throw new Exception("Book not found.");

            var exsistringCoverPhotoId = book.CoverPhotoId ?? 0;

            Mapper.Map(dto, book);

            if (dto.image == null && exsistringCoverPhotoId > 0)// ne može se null dodsjeliti 0
            {
                book.CoverPhotoId = exsistringCoverPhotoId;
            }
            else if (dto.image != null)
            {
                if (exsistringCoverPhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringCoverPhotoId, Data = dto.image };
                    var photo = await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.image };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    book.CoverPhotoId = photo.Id;
                }
            }

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }
    }
}
