


using eBiblioteka.Api;
using eBiblioteka.Application;
using eBiblioteka.Infrastructure;
using Microsoft.EntityFrameworkCore;


namespace eBiblioteka.Api
{
    public static class Registry
    {
        public static T BindConfig<T>(this WebApplicationBuilder builder, string key) where T : class
        {
            var section = builder.Configuration.GetSection(key);
            builder.Services.Configure<T>(section);
            return section.Get<T>()!;
        }

        public static void AddMapper(this IServiceCollection services)
        {
            services.AddAutoMapper(typeof(Program), typeof(BaseProfile));
        }

        public static void AddDatabase(this IServiceCollection services, ConnectionStringConfig config)
        {
            services.AddDbContext<DatabaseContext>(options => options.UseSqlServer(config.Main));
        }

        public static void AddSwagger(this IServiceCollection services)
        {
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();
            
        }


    }
}
