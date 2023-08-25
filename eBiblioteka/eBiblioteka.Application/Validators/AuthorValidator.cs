using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class AuthorValidator : AbstractValidator<AuthorUpsertDto>
    {
        public AuthorValidator()
        {
            RuleFor(u => u.FullName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.GenderId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(u=>u.BirthYear).NotNull().WithErrorCode(ErrorCodes.NotNull);

            RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
