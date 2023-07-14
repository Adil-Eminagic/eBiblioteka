using eBiblioteka.Application.Interfaces;
using eBiblioteka.Core;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace eBiblioteka.Application
{
    public static class Registry
    {
        public static void AddApplication(this IServiceCollection services)
        {
            services.AddScoped<ICitiesService, CitiesService>();
            services.AddScoped<ICountriesService, CountriesService>();
            services.AddScoped<IPhotosService, PhotosService>();
            services.AddScoped<IBooksService, BooksService>();
            services.AddScoped<IQuotesService, QuotesService>();
            services.AddScoped<IAuthorsService, AuthorsService>();
            services.AddScoped<IUsersService, UsersService>();
            services.AddScoped<IGenresService, GenresService>();
            services.AddScoped<IUserBooksService, UserBooksService>();
            services.AddScoped<IBookGenresService, BookGenresService>();
            services.AddScoped<IGendersService,GendersService>();
            services.AddScoped<IRolesService, RolesService>();
        }

        public static void AddValidators(this IServiceCollection services)
        {
            services.AddScoped<IValidator<CityUpsertDto>, CityValidator>();
            services.AddScoped<IValidator<CountryUpsertDto>, CountryValidator>();
            services.AddScoped<IValidator<PhotoUpsertDto>, PhotoValidator>();
            services.AddScoped<IValidator<BookUpsertDto>, BookValidator>();
            services.AddScoped<IValidator<QuoteUpsertDto>, QuoteValidator>();
            services.AddScoped<IValidator<AuthorUpsertDto>, AuthorValidator>();
            services.AddScoped<IValidator<UserUpsertDto>, UserValidator>();
            services.AddScoped<IValidator<GenreUpsertDto>, GenreValidator>();
            services.AddScoped<IValidator<UserBookUpsertDto>, UserBookValidator>();
            services.AddScoped<IValidator<BookGenreUpsertDto>, BookGenreValidator>();
            services.AddScoped<IValidator<GenderUpsertDto>, GenderValidator>();
            services.AddScoped<IValidator<RoleUpsertDto>, RoleValidator>();
            services.AddScoped<IValidator<UserChangePasswordDto>, UserPasswordValidator>();


        }
    }
}
