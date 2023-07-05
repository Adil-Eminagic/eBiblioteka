using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class GenderConfiguration : BaseConfiguration<Gender>
    {
        public override void Configure(EntityTypeBuilder<Gender> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Value)
                   .IsRequired();
           
        }
    }
}
