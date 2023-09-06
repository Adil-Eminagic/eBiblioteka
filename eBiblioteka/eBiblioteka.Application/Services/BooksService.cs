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
        private readonly IBookFilesService _bookFilesService;
        private readonly IRecommendResultsService _recommendResultsService;


        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator, IPhotosService photosService, IBookFilesService bookFilesService, IUserBooksRepository userBooksRepository, IUsersService usersService, IUsersRepository usersRepository, IRecommendResultsService recommendResultsService) : base(mapper, unitOfWork, validator)
        {
            _photosService = photosService;
            _bookFilesService = bookFilesService;
            _recommendResultsService = recommendResultsService;
        }


        public async override Task<BookDto> AddAsync(BookUpsertDto dto, CancellationToken cancellationToken = default)
        {
            await ValidateAsync(dto, cancellationToken);

            var entity = Mapper.Map<Book>(dto);
            if (dto.Image != null)
            {
                PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto();
                photoUpsertDto.Data = dto.Image;
                var photo = await _photosService.AddAsync(photoUpsertDto);
                entity.CoverPhotoId = photo.Id;
            }
            if (dto.Document != null)
            {
                BookFileUpsertDto bookFileUpsertDto = new BookFileUpsertDto();
                bookFileUpsertDto.Name = dto.Document.Name;
                bookFileUpsertDto.Data = dto.Document.Data;
                var file = await _bookFilesService.AddAsync(bookFileUpsertDto);
                entity.BookFileId = file.Id;
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
            var exsistringBookFileId = book.BookFileId ?? 0;

            Mapper.Map(dto, book);

            if (dto.Image == null && exsistringCoverPhotoId > 0)// ne može se null dodsjeliti 0
            {
                book.CoverPhotoId = exsistringCoverPhotoId;
            }
            else if (dto.Image != null)
            {
                if (exsistringCoverPhotoId > 0)
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = exsistringCoverPhotoId, Data = dto.Image };
                    await _photosService.UpdateAsync(photoUpsertDto);
                }
                else
                {
                    PhotoUpsertDto photoUpsertDto = new PhotoUpsertDto() { Id = 0, Data = dto.Image };
                    var photo = await _photosService.AddAsync(photoUpsertDto);
                    book.CoverPhotoId = photo.Id;
                }
            }


            if (dto.Document == null && exsistringBookFileId > 0)// ne može se null dodsjeliti 0
            {
                book.BookFileId = exsistringBookFileId;
            }
            else if (dto.Document != null)
            {
                if (exsistringBookFileId > 0)
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = exsistringBookFileId, Name = dto.Document.Name, Data = dto.Document.Data };
                    await _bookFilesService.UpdateAsync(fileUpsertDto);
                }
                else
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = 0, Name = dto.Document.Name, Data = dto.Document.Data };
                    var file = await _bookFilesService.AddAsync(fileUpsertDto);
                    book.BookFileId = file.Id;
                }
            }

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

        public async Task<BookDto> OpenBookAsync(int bookId, CancellationToken cancellationToken)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);
            if (book == null)
                throw new Exception("Book not found.");

            book.OpeningCount++;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

       
    }
}
