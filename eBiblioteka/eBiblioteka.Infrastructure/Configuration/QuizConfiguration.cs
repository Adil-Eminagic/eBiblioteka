using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class QuizConfiguration : BaseConfiguration<Quiz>
    {
        public override void Configure(EntityTypeBuilder<Quiz> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Title)
                   .IsRequired();
            builder.Property(e => e.Description)
                  .IsRequired(false);

        }
    }
}
