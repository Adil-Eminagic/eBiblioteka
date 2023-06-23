using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class BookGenresConfiguration : BaseConfiguration<BookGenre>
    {
        public override void Configure(EntityTypeBuilder<BookGenre> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Book)
                   .WithMany(e => e.Genres)
                   .HasForeignKey(e => e.BookId)
                   .IsRequired();

            builder.HasOne(e => e.Genre)
                   .WithMany(e => e.Books)
                   .HasForeignKey(e => e.GenreId)
                   .IsRequired();

        }
    }
}
