using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class UserQuizsService : BaseService<UserQuiz, UserQuizDto, UserQuizUpsertDto, UserQuizsSearchObject, IUserQuizsRepository>, IUserQuizsService
    {
        public UserQuizsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<UserQuizUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
