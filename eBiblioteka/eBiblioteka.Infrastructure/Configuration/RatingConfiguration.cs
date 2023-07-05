using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class RatingConfiguration : BaseConfiguration<Rating>
    {
        public override void Configure(EntityTypeBuilder<Rating> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Stars)
                   .IsRequired();
            builder.Property(e => e.Comment)
                  .IsRequired(false);
            builder.Property(e => e.DateTime)
                  .IsRequired();

            builder.HasOne(e => e.User)
                   .WithMany(e => e.RateBook)
                   .HasForeignKey(e => e.UserId)
                   .OnDelete(DeleteBehavior.NoAction);

            builder.HasOne(e => e.Book)
                 .WithMany(e => e.UserRate)
                 .HasForeignKey(e => e.BookId)
                 .IsRequired();
        }
    }
}
