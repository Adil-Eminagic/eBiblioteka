using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class QuoteConfiguration : BaseConfiguration<Quote>
    {
        public override void Configure(EntityTypeBuilder<Quote> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Content)
                   .IsRequired();


            builder.HasOne(e => e.Book)
                   .WithMany(e => e.Quotes)
                   .HasForeignKey(e => e.BookId)
                   .IsRequired();
        }
    }
}
