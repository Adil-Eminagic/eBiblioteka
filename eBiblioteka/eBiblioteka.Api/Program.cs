using eBiblioteka.Api;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json.Serialization;

using eBiblioteka.Application;
using eBiblioteka.Infrastructure;

var webAppBuilder = WebApplication.CreateBuilder(args);

// Add services to the container.

var connectionStringConfig = webAppBuilder.BindConfig<ConnectionStringConfig>("ConnectionStrings");
var jwtTokenConfig = webAppBuilder.BindConfig<JwtTokenConfig>("JwtToken");


webAppBuilder.Services.AddMapper();
webAppBuilder.Services.AddValidators();
webAppBuilder.Services.AddApplication();
webAppBuilder.Services.AddInfrastructure();
webAppBuilder.Services.AddDatabase(connectionStringConfig);
webAppBuilder.Services.AddAuthenticationAndAuthorization(jwtTokenConfig);
webAppBuilder.Services.AddResponseCaching();
webAppBuilder.Services.AddOther();
webAppBuilder.Services.AddControllers().AddNewtonsoftJson()
                      .AddJsonOptions(options =>
                      {
                          options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
                          options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
                      });

webAppBuilder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.SuppressModelStateInvalidFilter = true;
});
webAppBuilder.Services.AddCors(options => options.AddPolicy(
    name: "CorsPolicy",
    builder => builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader()
));

webAppBuilder.Services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = true);

if (webAppBuilder.Environment.IsDevelopment())
{
    webAppBuilder.Services.AddSwagger();
}

var app = webAppBuilder.Build();
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("CorsPolicy");
app.UseHttpsRedirection();
app.UseResponseCaching();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();