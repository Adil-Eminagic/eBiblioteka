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
            RuleFor(c=>c.Points).GreaterThan(0).LessThan(11).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);

        }
    }
}
