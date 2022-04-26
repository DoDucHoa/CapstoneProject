using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.API.Config
{
    public static class AuthConfig
    {
        public static void ConfigFirebaseAuth(this IServiceCollection services)
        {
            Environment.SetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS", "pawnclaw-4b6ba-firebase-adminsdk-txxl7-50dcc161a7.json");
            FirebaseApp.Create(new AppOptions
            {
                Credential = GoogleCredential.GetApplicationDefault(),
                //Credential = GoogleCredential.FromFile(@"..\auth-club-management-dev-firebase-adminsdk-j4jta-9138e37c11.json"),
            });
            services.AddAuthentication(opt =>
            {
                opt.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                opt.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
            })
                .AddJwtBearer(options =>
                {
                    options.RequireHttpsMetadata = false;
                    options.SaveToken = true;
                    //options.Authority = "https://securetoken.google.com/tutor-helper-6faa2";
                    options.TokenValidationParameters = new TokenValidationParameters
                    {
                        ClockSkew = TimeSpan.Zero,
                        ValidateIssuer = false,
                        //ValidIssuer = "https://securetoken.google.com/tutor-helper-6faa2",
                        ValidateAudience = false,
                        //ValidAudience = "tutor-helper-6faa2",
                        //ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("superSecretKey@345"))
                    };
                });
        }
    }
}
