using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookValidator : AbstractValidator<BookUpsertDto>
    {
        public BookValidator()
        {
            RuleFor(c => c.Title).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.PublishingDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CoverPhotoId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.OpeningCount).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
