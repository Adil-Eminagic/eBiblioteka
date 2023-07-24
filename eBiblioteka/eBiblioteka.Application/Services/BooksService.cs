using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;

namespace eBiblioteka.Application
{
    public class BooksService : BaseService<Book, BookDto, BookUpsertDto, BooksSearchObject, IBooksRepository>, IBooksService
    {
        private readonly IPhotosService _photosService;

        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
            this._photosService = photosService;
        }

        //public async override Task<BookDto?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        //{
        //    var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
        //    var dto = Mapper.Map<BookDto>(entity);
        //    if (entity.UserRate.Count > 0)
        //    {
        //        int ave = 0;
        //        foreach (var item in entity.UserRate)
        //        {
        //            ave += item.Stars;
        //        }
        //        dto.AverageRate = ave / entity.UserRate.Count;
        //    }

        //    return dto;
        //}

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
                        int ave = 0;
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
