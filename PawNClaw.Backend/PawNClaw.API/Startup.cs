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

            services.AddTransient<IRoleRepository, RoleRepository>();
            services.AddTransient<RoleRepository, RoleRepository>();

            services.AddTransient<IAccountRepository, AccountRepository>();
            services.AddTransient<AccountRepository, AccountRepository>();

            services.AddTransient<IAdminRepository, AdminRepository>();
            services.AddTransient<AdminRepository, AdminRepository>();

            services.AddTransient<IOwnerRepository, OwnerRepository>();
            services.AddTransient<OwnerRepository, OwnerRepository>();

            services.AddTransient<IStaffRepository, StaffRepository>();
            services.AddTransient<StaffRepository, StaffRepository>();

            services.AddTransient<ICustomerRepository, CustomerRepository>();
            services.AddTransient<CustomerRepository, CustomerRepository>();

            services.AddControllers();
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "PawNClaw.API", Version = "v1" });
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

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
