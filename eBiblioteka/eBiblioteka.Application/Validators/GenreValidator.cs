using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class GenreValidator : AbstractValidator<GenreUpsertDto>
    {
        public GenreValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
          
        }
    }
}
