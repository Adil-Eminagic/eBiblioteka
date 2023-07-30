using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class BookFileValidator : AbstractValidator<BookFileUpsertDto>
    {
        public BookFileValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Data).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
          
        }
    }
}
