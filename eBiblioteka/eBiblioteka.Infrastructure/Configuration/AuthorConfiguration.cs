using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class AuthorConfiguration : BaseConfiguration<Author>
    {
        public override void Configure(EntityTypeBuilder<Author> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.FullName)
                   .IsRequired();
            builder.Property(e => e.BirthDate)
                  .IsRequired();
            builder.Property(e => e.Biography)
                  .IsRequired(false);
            builder.Property(e => e.MortalDate)
                .IsRequired(false);
           

            builder.HasOne(e => e.Country)
                   .WithMany(e => e.Authors)
                   .HasForeignKey(e => e.CountryId)
                   .IsRequired();

            builder.HasOne(e => e.Gender)
                  .WithMany(e => e.Authors)
                  .HasForeignKey(e => e.GenderId)
                  .IsRequired();
        }
    }
}
