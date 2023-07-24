using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class AnswersService : BaseService<Answer, AnswerDto, AnswerUpsertDto, AnswersSearchObject, IAnswersRepository>, IAnswersService
    {
        public AnswersService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<AnswerUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
