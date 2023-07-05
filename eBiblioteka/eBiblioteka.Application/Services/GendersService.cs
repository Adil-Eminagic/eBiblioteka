using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class GendersService : BaseService<Gender, GenderDto, GenderUpsertDto, BaseSearchObject, IGendersRepository>, IGendersService
    {
        public GendersService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<GenderUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
