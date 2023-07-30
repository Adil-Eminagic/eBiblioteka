using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class RecommendResultValidator : AbstractValidator<RecommendResultUpsertDto>
    {
        public RecommendResultValidator()
        {
            RuleFor(u => u.BookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.FirstCobookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(u => u.SecondCobookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ThirdCobookId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
