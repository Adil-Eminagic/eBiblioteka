using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class GenresService : BaseService<Genre, GenreDto, GenreUpsertDto, GenresSearchObject, IGenresRepository>, IGenresService
    {
        public GenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<GenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

    }
}
