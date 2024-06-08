using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class ToDo210923sService : BaseService<ToDo210923, ToDo210923Dto, ToDo210923UpsertDto, ToDo210923sSearchObject, IToDo210923sRepository>, IToDo210923sService
    {
        public ToDo210923sService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ToDo210923UpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
