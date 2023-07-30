using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class RecommendResultConfiguration : BaseConfiguration<RecommendResult>
    {
        public override void Configure(EntityTypeBuilder<RecommendResult> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.BookId)
                   .IsRequired();
            builder.Property(e => e.FirstCobookId)
                  .IsRequired();
            builder.Property(e => e.SecondCobookId)
                  .IsRequired();
            builder.Property(e => e.ThirdCobookId)
                  .IsRequired();



        }
    }
}
