
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
        public DbSet<Genre> Genres { get; set; }
        public DbSet<Author> Authors { get; set; }
        public DbSet<UserBook> UserBooks { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<BookGenre> BookGenres { get; set; }


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);
        }
    }
}
