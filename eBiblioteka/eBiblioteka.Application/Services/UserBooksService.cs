using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class UserBooksService : BaseService<UserBook, UserBookDto, UserBookUpsertDto, UserBooksSearchObject, IUserBooksRepository>, IUserBooksService
    {
        public UserBooksService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserBookUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
