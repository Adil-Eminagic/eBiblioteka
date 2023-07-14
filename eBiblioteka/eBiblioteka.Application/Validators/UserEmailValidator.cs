
using eBiblioteka.Core;
using FluentValidation;


namespace eBiblioteka.Application
{
    public class UserEmailValidator : AbstractValidator<UserEmailUpsertDto>
    {
        public UserEmailValidator()
        {
            RuleFor(u => u.LastName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
