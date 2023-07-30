
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.Extensions.DependencyInjection;
namespace eBiblioteka.Infrastructure
{
    public static class Registry
    {
        public static void AddInfrastructure(this IServiceCollection services)
        {
            services.AddScoped<ICountriesRepository, CountriesRepository>();
            services.AddScoped<IPhotosRepository,PhotosRepository>();
            services.AddScoped<IBooksRepository, BooksRepository>();
            services.AddScoped<IQuotesRepository, QuotesRepository>();
            services.AddScoped<IGenresRepository, GenresRepository>();
            services.AddScoped<IAuthorsRepository, AuthorsRepository>();
            services.AddScoped<IUsersRepository, UsersRepository>();
            services.AddScoped<IUserBooksRepository, UserBooksRepository>();
            services.AddScoped<IBookGenresRepository, BookGenresRepository>();
            services.AddScoped<IRatingsRepository, RatingsRepository>();
            services.AddScoped<IGendersRepository, GendersRepository>();
            services.AddScoped<IRolesRepository, RolesRepository>();
            services.AddScoped<IQuizsRepository, QuizsRepository>();
            services.AddScoped<IQuestionsRepository, QuestionsRepository>();
            services.AddScoped<IAnswersRepository, AnswersRepository>();
            services.AddScoped<INotificationsRepository, NotificationsRepository>();
            services.AddScoped<IBookFilesRepository, BookFilesRepository>();
            services.AddScoped<IRecommendResultsRepository, RecommendResultsRepository>();

            services.AddScoped<IUnitOfWork, UnitOfWork>();
        }
    }
}
