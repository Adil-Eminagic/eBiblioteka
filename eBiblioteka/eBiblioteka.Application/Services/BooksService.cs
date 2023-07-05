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
        public BooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public async Task<IEnumerable<BookDto>> GetByAuthorIdAsync(int authorId, CancellationToken cancellationToken)
        {
            var books= await CurrentRepository.GetByAuthorIdAsync(authorId, cancellationToken);
            return Mapper.Map<IEnumerable<BookDto>>(books);
        }
    }
}
