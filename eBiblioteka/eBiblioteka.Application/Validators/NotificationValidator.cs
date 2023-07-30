using FluentValidation;

using eBiblioteka.Core;

namespace eBiblioteka.Application
{
    public class NotificationValidator : AbstractValidator<NotificationUpsertDto>
    {
        public NotificationValidator()
        {
            RuleFor(u => u.Title).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(u => u.isRead).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.UserId).NotNull().WithErrorCode(ErrorCodes.NotNull);

        }
    }
}
