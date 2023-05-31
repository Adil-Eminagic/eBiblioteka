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
        }

        public static void AddValidators(this IServiceCollection services)
        {
            services.AddScoped<IValidator<CityUpsertDto>, CityValidator>();
            services.AddScoped<IValidator<CountryUpsertDto>, CountryValidator>();
            services.AddScoped<IValidator<PhotoUpsertDto>, PhotoValidator>();
            services.AddScoped<IValidator<BookUpsertDto>, BookValidator>();
            services.AddScoped<IValidator<QuoteUpsertDto>, QuoteValidator>();
           
        }
    }
}
