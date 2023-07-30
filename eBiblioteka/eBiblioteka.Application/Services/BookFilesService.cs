using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class BookFilesService : BaseService<BookFile, BookFileDto, BookFileUpsertDto, BaseSearchObject, IBookFilesRepository>, IBookFilesService
    {
        public BookFilesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookFileUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
