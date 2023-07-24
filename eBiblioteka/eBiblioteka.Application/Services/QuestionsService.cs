using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class QuestionsService : BaseService<Question, QuestionDto, QuestionUpsertDto, QuestionsSearchObject, IQuestionsRepository>, IQuestionsService
    {
        public QuestionsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<QuestionUpsertDto> validator, IPhotosService photosService) : base(mapper, unitOfWork, validator)
        {
        }

        public override async Task<PagedList<QuestionDto>> GetPagedAsync(QuestionsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            var dtos= Mapper.Map<PagedList<QuestionDto>>(pagedList);
            if(pagedList!= null && pagedList.Items.Count > 0)
            {
                for(int i = 0; i < pagedList.Items.Count; i++)
                {
                    if (pagedList.Items[i].Answers.Count<2)
                        dtos.Items[i].isActive = false;
                    else
                    {
                        var _true = 0;
                        var _false = 0;
                        foreach (var z in pagedList.Items[i].Answers)
                        {
                            if (z.IsTrue)
                                _true++;
                            else 
                                _false++;
                        }
                        if (_true != 1)
                            dtos.Items[i].isActive = false;
                        else if (_false < 1)
                            dtos.Items[i].isActive = false;
                        else
                            dtos.Items[i].isActive = true;

                    }

                }
            }

            return dtos;
            
        }
    }
}
