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
builder.WebHost.UseKestrel(options =>
{
    options.Limits.MaxRequestBodySize = 2147483647; //50MB
    options.Limits.MaxRequestBufferSize = 2147483647; //50MB
    options.Limits.MaxResponseBufferSize = 2147483647;
    options.Limits.KeepAliveTimeout = TimeSpan.FromMinutes(10);
    options.Limits.RequestHeadersTimeout = TimeSpan.FromMinutes(10);
});

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

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/EnvioNotificacion/swagger.json", "Envio de notificaciones");
});
app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.MapControllerRoute(
    name: "default",
    pattern: "api/{namespace}/{controller=Home}/{action=Index}/{id?}");
app.Run();
