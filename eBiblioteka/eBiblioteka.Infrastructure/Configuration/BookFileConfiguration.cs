using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class BookFileConfiguration : BaseConfiguration<BookFile>
    {
        public override void Configure(EntityTypeBuilder<BookFile> builder)
        {
            base.Configure(builder);

            builder.Property(e=>e.Name).IsRequired();

            builder.Property(e => e.Data)
                   .IsRequired();

           
        }
    }
}
