using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class QuestionValidator : AbstractValidator<QuestionUpsertDto>
    {
        public QuestionValidator()
        {
            RuleFor(u => u.Content).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.QuizId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
