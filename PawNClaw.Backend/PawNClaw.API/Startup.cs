using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using PawNClaw.API.Config;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static PawNClaw.Data.Repository.PetCenterRepository;

namespace PawNClaw.API
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.ConfigFirebaseAuth();
            services.AddTransient<AuthService, AuthService>();



            services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));
            services.AddControllers();
            services.AddHttpClient();

            services.AddTransient<SearchService, SearchService>();

            services.AddTransient<IRoleRepository, RoleRepository>();

            services.AddTransient<IAccountRepository, AccountRepository>();
            services.AddTransient<AccountService, AccountService>();

            services.AddTransient<IAdminRepository, AdminRepository>();
            services.AddTransient<AdminService, AdminService>();

            services.AddTransient<IOwnerRepository, OwnerRepository>();
            services.AddTransient<OwnerService, OwnerService>();

            services.AddTransient<IStaffRepository, StaffRepository>();
            services.AddTransient<StaffServicecs, StaffServicecs>();

            services.AddTransient<ICustomerRepository, CustomerRepository>();

            services.AddTransient<IBrandRepository, BrandRepository>();
            services.AddTransient<BrandService, BrandService>();

            services.AddTransient<IPetCenterRepository, PetCenterRepository>();
            services.AddTransient<PetCenterService, PetCenterService>();

            services.AddTransient<IBookingDetailRepository, BookingDetailRepository>();

            services.AddTransient<IPetRepository, PetRepository>();
            services.AddTransient<PetService, PetService>();

            services.AddTransient<ILocationRepository, LocationRepository>();

            services.AddTransient<IBookingRepository, BookingRepository>();

            services.AddTransient<ICageRepository, CageRepository>();

            services.AddTransient<IPhotoRepository, PhotoRepository>();

            services.AddTransient<ICityRepository, CityRepository>();
            services.AddTransient<CityService, CityService>();

            services.AddTransient<IDistrictRepository, DistrictRepository>();
            services.AddTransient<DistrictService, DistrictService>();

            services.AddControllers();
            services.AddControllersWithViews()
                    .AddNewtonsoftJson(options =>
                    options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
                    );
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "PawNClaw.API", Version = "v1" });
                c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
                {
                    Description = @"JWT Authorization header using the Bearer scheme. \r\n\r\n 
                      Enter 'Bearer' [space] and then your token in the text input below.
                      \r\n\r\nExample: 'Bearer 12345abcdef'",
                    Name = "Authorization",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.ApiKey,
                    Scheme = "Bearer"
                });

                c.AddSecurityRequirement(new OpenApiSecurityRequirement()
                {
                    {
                        new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme,
                                Id = "Bearer"
                            },
                                Scheme = "oauth2",
                                Name = "Bearer",
                                In = ParameterLocation.Header,
                            },
                        new List<string>()
                    }
                });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "PawNClaw.API v1"));
            }

            app.UseSwagger();
            app.UseSwaggerUI(c => { c.SwaggerEndpoint("/swagger/v1/swagger.json", "PawNClaw.API v1"); c.RoutePrefix = string.Empty; });

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
