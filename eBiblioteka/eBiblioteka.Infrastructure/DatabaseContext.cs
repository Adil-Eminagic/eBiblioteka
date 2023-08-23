
using eBiblioteka.Core;
using Microsoft.EntityFrameworkCore;

namespace eBiblioteka.Infrastructure
{
    public partial class DatabaseContext :DbContext
    {
        public DatabaseContext(DbContextOptions<DatabaseContext> context):base(context) { }


        //Entites
        public DbSet<Gender> Genders { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<Photo> Photos { get; set; }
        public DbSet<Book> Books { get; set; }
        public DbSet<Quote> Quotes { get; set; }
        public DbSet<Role> Genres { get; set; }
        public DbSet<Author> Authors { get; set; }
        public DbSet<UserBook> UserBooks { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<BookGenre> BookGenres { get; set; }
        public DbSet<Rating> Ratings { get; set; }
        public DbSet<Quiz> Quizzes { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<Answer> Answers { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<BookFile> BookFiles { get; set; }
        public DbSet<RecommendResult> RecommendResults { get; set; }
        public DbSet<UserQuiz> UserQuizzes { get; set; }



        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);
        }
    }
}
