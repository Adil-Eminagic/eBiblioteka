using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class ToDo210923Validator : AbstractValidator<ToDo210923UpsertDto>
    {
        public ToDo210923Validator()
        {
            RuleFor(u => u.ActivityName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.ActivityDescription).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.StatusCode).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.FinshingDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
