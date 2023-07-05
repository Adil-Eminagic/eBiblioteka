using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class GenderValidator : AbstractValidator<GenderUpsertDto>
    {
        public GenderValidator()
        {
            RuleFor(u => u.Value).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
          
        }
    }
}
