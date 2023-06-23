using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class AuthorValidator : AbstractValidator<AuthorUpsertDto>
    {
        public AuthorValidator()
        {
            RuleFor(u => u.FirstName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.LastName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.Gender).IsInEnum().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(u => u.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);

            RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
