using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class BookGenresService : BaseService<BookGenre, BookGenreDto, BookGenreUpsertDto, BookGenresSearchObject, IBookGenresRepository>, IBookGenresService
    {
        public BookGenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookGenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public async override Task<BookGenreDto> AddAsync(BookGenreUpsertDto dto, CancellationToken cancellationToken = default)
        {
            var entities = await CurrentRepository.GetPagedAsync(new BookGenresSearchObject() {BookId=dto.BookId, GenreId= dto.GenreId }, cancellationToken);


            if (entities != null &&  entities.TotalCount > 0)
                throw new Exception("You have already added this genre to this book. You cann't add same genres multiple times.");


            return await base.AddAsync(dto, cancellationToken);
        }

    }
}
