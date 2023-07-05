using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RoleValidator : AbstractValidator<RoleUpsertDto>
    {
        public RoleValidator()
        {
            RuleFor(u => u.Value).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
           
        }
    }
}
