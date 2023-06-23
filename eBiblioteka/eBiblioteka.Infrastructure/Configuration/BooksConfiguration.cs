using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class BooksConfiguration : BaseConfiguration<Book>
    {
        public override void Configure(EntityTypeBuilder<Book> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Title)
                   .IsRequired();

            builder.Property(e => e.ShortDescription)
                   .IsRequired(false);

            builder.Property(e => e.PublishingYear)
                   .IsRequired(false);

            builder.Property(e => e.OpeningCount)
                   .IsRequired();

            builder.HasOne(e => e.CoverPhoto)
                   .WithMany(e => e.Books)
                   .HasForeignKey(e => e.CoverPhotoId)
                   .IsRequired(false);


            builder.HasOne(e => e.Author)
                   .WithMany(e => e.Books)
                   .HasForeignKey(e => e.AuthorID)
                   .IsRequired();

        }
    }
}
