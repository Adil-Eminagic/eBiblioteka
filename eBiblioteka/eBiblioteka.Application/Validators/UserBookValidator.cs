using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class UserBookValidator : AbstractValidator<UserBookUpsertDto>
    {
        public UserBookValidator()
        {
            RuleFor(c => c.BookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
