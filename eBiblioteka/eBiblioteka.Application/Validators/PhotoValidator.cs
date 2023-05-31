using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class PhotoValidator : AbstractValidator<PhotoUpsertDto>
    {
        public PhotoValidator()
        {
            RuleFor(c => c.Data).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
          
        }
    }
}
