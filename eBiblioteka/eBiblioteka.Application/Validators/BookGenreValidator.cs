using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookGenreValidator : AbstractValidator<BookGenreUpsertDto>
    {
        public BookGenreValidator()
        {
            RuleFor(c => c.BookId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.GenreId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
