using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eBiblioteka.Infrastructure
{
    public class ToDo210923Configuration : BaseConfiguration<ToDo210923>
    {
        public override void Configure(EntityTypeBuilder<ToDo210923> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.ActivityName)
                   .IsRequired();
            builder.Property(e => e.ActivityDescription)
                  .IsRequired();
            builder.Property(e => e.FinshingDate)
                 .IsRequired();

            builder.Property(e => e.StatusCode)
                 .IsRequired();

            builder.HasOne(e => e.User)
                   .WithMany(e => e.ToDo210923s)
                   .HasForeignKey(e => e.UserId)
                   .IsRequired();

        }
    }
}
