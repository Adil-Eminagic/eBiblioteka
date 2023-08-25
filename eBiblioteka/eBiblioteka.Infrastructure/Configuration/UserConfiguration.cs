using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class UserConfiguration : BaseConfiguration<User>
    {
        public override void Configure(EntityTypeBuilder<User> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.FirstName)
                  .IsRequired();

            builder.Property(e => e.LastName)
                   .IsRequired();

            builder.Property(e => e.Email)
                   .IsRequired();

            builder.HasIndex(e => e.Email).IsUnique();

            builder.Property(e => e.PhoneNumber)
                   .IsRequired();

            builder.Property(e => e.PasswordHash)
                   .IsRequired();

            builder.Property(e => e.PasswordSalt)
                   .IsRequired();


            builder.Property(e => e.IsActive)
                   .IsRequired();

            builder.Property(e => e.LastSignInAt)
                   .IsRequired(false);


            builder.HasOne(e => e.ProfilePhoto)
                   .WithMany(e => e.Users)
                   .HasForeignKey(e => e.ProfilePhotoId)
                   .IsRequired(false);

            builder.HasOne(e => e.Country)
                 .WithMany(e => e.Users)
                 .HasForeignKey(e => e.CountryId)
                 .IsRequired();

            builder.HasOne(e => e.Role)
                 .WithMany(e => e.Users)
                 .HasForeignKey(e => e.RoleId)
                 .IsRequired();

            builder.HasOne(e => e.Gender)
                .WithMany(e => e.Users)
                .HasForeignKey(e => e.GenderId)
                .IsRequired();


            builder.Property(e => e.Biography)
                   .IsRequired(false);

            builder.Property(e => e.BirthDate)
                   .IsRequired();

            builder.Property(e => e.PurchaseDate)
                   .IsRequired(false);

            builder.Property(e => e.ExpirationDate)
                   .IsRequired(false);

            builder.Property(e => e.IsActiveMembership)
                .HasColumnName("IsActiveMembership")
            .HasComputedColumnSql("CAST(CASE WHEN PurchaseDate IS NOT NULL AND ExpirationDate IS NOT NULL AND ExpirationDate >= GETDATE() THEN 1 ELSE 0 END AS BIT)")
               .IsRequired();


        }
    }
}
