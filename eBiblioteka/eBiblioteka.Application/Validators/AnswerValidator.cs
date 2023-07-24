using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class AnswerValidator : AbstractValidator<AnswerUpsertDto>
    {
        public AnswerValidator()
        {
            RuleFor(u => u.Content).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.IsTrue).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.QuestionId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
