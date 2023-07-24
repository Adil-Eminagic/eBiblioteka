using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuizValidator : AbstractValidator<QuizUpsertDto>
    {
        public QuizValidator()
        {
            RuleFor(u => u.Title).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
