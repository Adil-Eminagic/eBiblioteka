using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuoteValidator : AbstractValidator<QuoteUpsertDto>
    {
        public QuoteValidator()
        {
            RuleFor(c => c.Content).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.BookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
