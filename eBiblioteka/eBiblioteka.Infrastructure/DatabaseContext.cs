
using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public partial class DatabaseContext :DbContext
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> context):base(context) { }
       

        //Entites
        public DbSet<Country> Countries { get; set; }
        public DbSet<City> Cities { get; set;}
        public DbSet<Photo> Photos { get; set; }
        public DbSet<Book> Books { get; set; }
        public DbSet<Quote> Quotes { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);
        }
    }
}
