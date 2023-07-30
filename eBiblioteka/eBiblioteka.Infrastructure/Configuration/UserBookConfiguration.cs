using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class UserBookConfiguration : BaseConfiguration<UserBook>
    {
        public override void Configure(EntityTypeBuilder<UserBook> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Book)
                    .WithMany(e => e.Readers)
                    .HasForeignKey(e => e.BookId)
                    .IsRequired();


            builder.HasOne(e => e.User)
                   .WithMany(e => e.OpenedBooks)
                   .HasForeignKey(e => e.UserId)
                   .OnDelete(DeleteBehavior.NoAction);

            builder.HasIndex(e => new { e.UserId, e.BookId }).IsUnique();

        }
    }
}
