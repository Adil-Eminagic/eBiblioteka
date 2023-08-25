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
                    if (pagedList.Items[i].Answers.Count<2)//if has les then two answers is flase
                        dtos.Items[i].IsActive = false;
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
                        if (_true != 1) //only one true answer
                            dtos.Items[i].IsActive = false;
                        else if (_false < 1) // if 0 false answrs false
                            dtos.Items[i].IsActive = false;
                        else
                            dtos.Items[i].IsActive = true;

                    }

                }
            }

            if (searchObject.IsActive != null)
            {
                dtos.Items = dtos.Items.Where(s => s.IsActive == searchObject.IsActive).ToList();
                dtos.TotalCount = dtos.Items.Count;

            }

            return dtos;
            
        }
    }
}
