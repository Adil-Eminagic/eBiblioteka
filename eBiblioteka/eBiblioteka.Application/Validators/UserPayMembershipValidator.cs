
using eBiblioteka.Core;
using FluentValidation;

namespace eBiblioteka.Application
{
    public class UserPayMembershipValidator : AbstractValidator<UserPayMembershipDto>
    {
        public UserPayMembershipValidator()
        {

            RuleFor(c=>c.PurchaseDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ExpirationDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ExpirationDate > c.PurchaseDate);

        }
    }
}
