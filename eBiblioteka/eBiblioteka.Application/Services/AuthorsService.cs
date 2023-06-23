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
        public AuthorsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<AuthorUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
