using AutoMapper;
using FluentValidation;
using eBiblioteka.Core;
using eBiblioteka.Application.Interfaces;
using eBiblioteka.Infrastructure;
using eBiblioteka.Infrastructure.Interfaces;

namespace eBiblioteka.Application
{
    public class BookGenresService : BaseService<BookGenre, BookGenreDto, BookGenreUpsertDto, BookGenresSearchObject, IBookGenresRepository>, IBookGenresService
    {
        public BookGenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<BookGenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public override async Task<PagedList<BookGenreDto>> GetPagedAsync(BookGenresSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
            var dtos = Mapper.Map<PagedList<BookGenreDto>>(pagedList);
            if (pagedList.Items != null && pagedList.Items.Count > 0)
            {
                for (int i = 0; i < pagedList.Items.Count(); i++)
                {
                    if (pagedList.Items[i].Book.UserRate.Count > 0)
                    {
                        int ave = 0;
                        foreach (var z in pagedList.Items[i].Book.UserRate)
                        {
                            ave += z.Stars;
                        }
                        dtos.Items[i].Book.AverageRate = ave / pagedList.Items[i].Book.UserRate.Count();
                    }
                }
            }

            return dtos;
        }

    }
}
