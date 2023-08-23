using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class QuizsService : BaseService<Quiz, QuizDto, QuizUpsertDto, QuizzesSearchObject, IQuizsRepository>, IQuizsService
    {
        private readonly IQuestionsService _questionsService;

        public QuizsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<QuizUpsertDto> validator, IPhotosService photosService, IQuestionsService questionsService) : base(mapper, unitOfWork, validator)
        {
            _questionsService = questionsService;
        }

        public override async Task<PagedList<QuizDto>> GetPagedAsync(QuizzesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            var dtos = Mapper.Map<PagedList<QuizDto>>(pagedList);
            for (int i = 0; i < pagedList.Items.Count; i++)
            {
                if (pagedList.Items[i].Questions == null || pagedList.Items[i].Questions.Count == 0)
                {
                    dtos.Items[i].isActive = false;
                }
                else
                {
                    var questions = await _questionsService.GetPagedAsync(
                        new QuestionsSearchObject { QuizId = pagedList.Items[i].Id }, cancellationToken);
                    bool active = true;
                    foreach (var item in questions.Items)
                    {
                        if (item.isActive == false)
                            active = false;
                    }

                    dtos.Items[i].isActive = active;

                    dtos.Items[i].TotalPoints = 0;
                    foreach (var item in pagedList.Items[i].Questions)
                    {
                        dtos.Items[i].TotalPoints += item.Points;
                    }

                }

            }

            if(searchObject.isActive != null)
            {
                dtos.Items = dtos.Items.Where(s=>s.isActive==searchObject.isActive).ToList();
                dtos.TotalCount= dtos.Items.Count;
                
            }


            return dtos;

        }

    }
}
