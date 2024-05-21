using Microsoft.OpenApi.Models;
using Notificaciones.Modelo.Entidades.Notificaciones;
using Notificaciones.Negocio.Common;
using Notificaciones.Negocio.Negocios.Common;
using Notificaciones.Negocio.Negocios.Notificaciones;
using Notificaciones.Repositorio.Contratos.Common;
using Notificaciones.Repositorio.Contratos.Notificaciones;
using Notificaciones.Repositorio.Repositorios.Common;
using Notificaciones.Repositorio.Repositorios.Notificaciones;
using System.IdentityModel.Tokens.Jwt;
using System.Reflection;
using System.Text.Json.Serialization;
JwtSecurityTokenHandler.DefaultInboundClaimTypeMap.Clear();
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers()
    .AddJsonOptions(x => {
        x.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("EnvioNotificacion", new OpenApiInfo
    {
        Title = "Envio de notificaciones de SGD",
        Description = "Una Web API de ASP.NET Core para gestionar las notificaciones de SGD"
    });     
    c.SwaggerDoc("ValidadorNotificaciones", new OpenApiInfo
    {
        Title = "Validador de notificaciones de SGD",
        Description = "Una Web API de ASP.NET Core para gestionar las validaciones de notificaciones de SGD"
    });    
    //c.SwaggerDoc("Error", new OpenApiInfo
    //{
    //    Title = "Errores en las notificaciones",
    //    Description = "Una Web API de ASP.NET Core para gestionar los errores notificaciones de SGD"
    //});
    // Configuración para incluir comentarios XML de documentación
    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
    c.IncludeXmlComments(xmlPath);
    // Limita la cantidad de información generada
    c.IgnoreObsoleteActions();
    c.IgnoreObsoleteProperties();
}
);
builder.Services.AddScoped<EnvioNotificacionBusiness>();
builder.Services.AddScoped<ValidadorNotificacionesBusiness>();
builder.Services.AddScoped<IValidadorNotificacionRepositorio, ValidadorNotificacionRepositorio>();
builder.Services.AddScoped<IAlertaRepositorio, AlertaRepositorio>();
builder.Services.AddScoped<IBandejaRepositorio, BandejaRepositorio>();
builder.Services.AddScoped<ICategoriaNotificacionRepositorio, CategoriaNotificacionRepositorio>();
builder.Services.AddScoped<INotificacionRepositorio, NotificacionRepositorio>();

builder.Services.AddScoped<IGenericRepository<Alerta>, GenericRepository<Alerta>>();
builder.Services.AddScoped<IGenericRepository<Bandeja>, GenericRepository<Bandeja>>();
builder.Services.AddScoped<IGenericRepository<CategoriaNotificacion>, GenericRepository<CategoriaNotificacion>>();
builder.Services.AddScoped<IGenericRepository<Notificacion>, GenericRepository<Notificacion>>();

//builder.Services.AddScoped<IAlertaBusiness, AlertaBusiness>();
//builder.Services.AddScoped<IBandejaBusiness, BandejaBusiness>();
//builder.Services.AddScoped<ICategoriaNotificacionBusiness, CategoriaNotificacionBusiness>();
//builder.Services.AddScoped<INotificacionBusiness, NotificacionBusiness>();

builder.Services.AddScoped<IGenericBusiness<Alerta>, GenericBusiness<Alerta>>();
builder.Services.AddScoped<IGenericBusiness<Bandeja>, GenericBusiness<Bandeja>>();
builder.Services.AddScoped<IGenericBusiness<CategoriaNotificacion>, GenericBusiness<CategoriaNotificacion>>();
builder.Services.AddScoped<IGenericBusiness<Notificacion>, GenericBusiness<Notificacion>>();

builder.Services.AddAutoMapper(typeof(Program).Assembly);
builder.Services.AddDataProtection();
builder.Services.AddProblemDetails();
var app = builder.Build();
app.UseExceptionHandler();
app.UseStatusCodePages();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    //app.UseDeveloperExceptionPage();
    app.UseExceptionHandler("/error-development");
}
else
{
    // Middleware para manejo de errores en producción
    app.UseExceptionHandler("/error");
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/EnvioNotificacion/swagger.json", "Envio de notificaciones");
    c.SwaggerEndpoint("/swagger/ValidadorNotificaciones/swagger.json", "Validador de notificaciones");
    //c.SwaggerEndpoint("/swagger/Error/swagger.json", "Errores de las notificaciones");
});
app.UseHttpsRedirection();

app.UseAuthorization();
app.MapControllers();

app.MapControllerRoute(
    name: "default",
    pattern: "api/{namespace}/{controller=Home}/{action=Index}/{id?}");
app.Run();
