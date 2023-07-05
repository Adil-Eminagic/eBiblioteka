using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class RolesService : BaseService<Role, RoleDto, RoleUpsertDto, BaseSearchObject, IRolesRepository>, IRolesService
    {
        public RolesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<RoleUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
