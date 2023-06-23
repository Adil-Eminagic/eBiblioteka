
using eBiblioteka.Infrastructure.Interfaces;
using Microsoft.Extensions.DependencyInjection;
namespace eBiblioteka.Infrastructure
{
    public static class Registry
    {
        public static void AddInfrastructure(this IServiceCollection services)
        {
            services.AddScoped<ICitiesRepository, CitiesRepository>();
            services.AddScoped<ICountriesRepository, CountriesRepository>();
            services.AddScoped<IPhotosRepository,PhotosRepository>();
            services.AddScoped<IBooksRepository, BooksRepository>();
            services.AddScoped<IQuotesRepository, QuotesRepository>();
            services.AddScoped<IGenresRepository, GenresRepository>();
            services.AddScoped<IAuthorsRepository, AuthorsRepository>();
            services.AddScoped<IUsersRepository, UsersRepository>();
            services.AddScoped<IUserBooksRepository, UserBooksRepository>();
            services.AddScoped<IBookGenresRepository, BookGenreGenresRepository>();

            services.AddScoped<IUnitOfWork, UnitOfWork>();
        }
    }
}
