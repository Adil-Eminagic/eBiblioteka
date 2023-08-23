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
        private readonly IUsersRepository _usersRepository;


        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator, IPhotosService photosService, IBookFilesService bookFilesService, IUserBooksRepository userBooksRepository, IUsersService usersService, IUsersRepository usersRepository) : base(mapper, unitOfWork, validator)
        {
            this._photosService = photosService;
            _bookFilesService = bookFilesService;
            _usersRepository = usersRepository;
        }


        public override async Task<PagedList<BookDto>> GetPagedAsync(BooksSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            var dtos = Mapper.Map<PagedList<BookDto>>(pagedList);

            if (pagedList.Items != null && pagedList.Items.Count > 0)
            {
                for (int i = 0; i < pagedList.Items.Count(); i++)
                {
                    if (pagedList.Items[i].UserRate.Count > 0)
                    {
                        decimal ave = 0;
                        foreach (var z in pagedList.Items[i].UserRate)
                        {
                            ave += z.Stars;
                        }
                        dtos.Items[i].AverageRate = ave / pagedList.Items[i].UserRate.Count();
                    }
                }
            }

            return dtos;
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
            if (dto.document != null)
            {
                BookFileUpsertDto bookFileUpsertDto = new BookFileUpsertDto();
                bookFileUpsertDto.Name = dto.document.Name;
                bookFileUpsertDto.Data = dto.document.Data;
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


            if (dto.document == null && exsistringBookFileId > 0)// ne može se null dodsjeliti 0
            {
                book.BookFileId = exsistringBookFileId;
            }
            else if (dto.document != null)
            {
                if (exsistringBookFileId > 0)
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = exsistringBookFileId, Name = dto.document.Name, Data = dto.document.Data };
                    var file = await _bookFilesService.UpdateAsync(fileUpsertDto);
                }
                else
                {
                    BookFileUpsertDto fileUpsertDto = new BookFileUpsertDto() { Id = 0, Name = dto.document.Name, Data = dto.document.Data };
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

        public async Task<BookDto> DeactivateAsync(int bookId, CancellationToken cancellationToken = default)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);

            if (book == null)
                throw new UserNotFoundException();

            if (book.isActive == false)
                throw new Exception("Ne mozete deaktivirati knjigu koji je vec deakativirana");

            book.isActive = false;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }

        public async Task<BookDto> ActivateAsync(int bookId, CancellationToken cancellationToken = default)
        {
            var book = await CurrentRepository.GetByIdAsync(bookId, cancellationToken);

            if (book == null)
                throw new UserNotFoundException();

            if (book.isActive == true)
                throw new Exception("Ne mozete aktivirati knjigu koji je aktivna");

            book.isActive = true;

            CurrentRepository.Update(book);
            await UnitOfWork.SaveChangesAsync();

            return Mapper.Map<BookDto>(book);
        }
    }
}
