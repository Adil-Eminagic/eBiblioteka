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

    }
}
