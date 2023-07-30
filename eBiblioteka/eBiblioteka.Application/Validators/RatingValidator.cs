using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RatingValidator : AbstractValidator<RatingUpsertDto>
    {
        public RatingValidator()
        {
            RuleFor(u => u.Stars).LessThan(6).GreaterThan(0).NotNull().WithErrorCode(ErrorCodes.NotNull);

            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.BookId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
