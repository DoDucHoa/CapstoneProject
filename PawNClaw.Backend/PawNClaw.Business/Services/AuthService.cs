﻿using FirebaseAdmin.Auth;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.IdentityModel.Tokens;
using PawNClaw.Data.Const;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Services
{
    public class AuthService
    {
        private readonly IAccountRepository _repository;
        private readonly IRoleRepository _roleRepository;
        private readonly IAdminRepository _adminRepository;
        private readonly IOwnerRepository _ownerRepository;
        private readonly IStaffRepository _staffRepository;
        private readonly ICustomerRepository _customerRepository;
        private readonly IPhotoRepository _photoRepository;

        private readonly ApplicationDbContext _db;

        public AuthService(IAccountRepository userInfoRepository, IRoleRepository roleRepository,
            IAdminRepository adminRepository, IOwnerRepository ownerRepository,
            IStaffRepository staffRepository, ICustomerRepository customerRepository,
            IPhotoRepository photoRepository, ApplicationDbContext db)
        {
            _repository = userInfoRepository;
            _roleRepository = roleRepository;
            _adminRepository = adminRepository;
            _ownerRepository = ownerRepository;
            _staffRepository = staffRepository;
            _customerRepository = customerRepository;
            _photoRepository = photoRepository;
            _db = db;
        }

        //register
        public async Task<LoginViewModel> Register(LoginRequestModel loginrequestmodel, AccountCreateParameter _account, CustomerCreateParameter _customer)
        {
            var userViewModel = await VerifyFirebaseTokenIdRegister(loginrequestmodel.IdToken, _account, _customer);
            var claims = new List<Claim>
            {
                new(ClaimTypes.Name, userViewModel.Name != null ? userViewModel.Name : ""),
                new(ClaimTypes.Email, userViewModel.UserName),
                new(ClaimTypes.Role, userViewModel.Role),
            };

            var accessToken = GenerateAccessToken(claims);
            // var refreshToken = GenerateRefreshToken();

            userViewModel.JwtToken = accessToken;
            return userViewModel;
        }

        //verify for register
        public async Task<LoginViewModel> VerifyFirebaseTokenIdRegister(string idtoken, AccountCreateParameter _account, CustomerCreateParameter _customer)
        {
            FirebaseToken decodedtoken;
            try
            {
                decodedtoken = await FirebaseAuth.DefaultInstance
                       .VerifyIdTokenAsync(idtoken);
            }
            catch
            {
                throw new Exception();
            }
            string uid = decodedtoken.Uid;
            var user = await FirebaseAuth.DefaultInstance.GetUserAsync(uid);

            //Create new Account and Customer
            Account accountToDb = new Account();
            accountToDb.UserName = _account.UserName;
            accountToDb.Status = true;
            accountToDb.RoleCode = _account.RoleCode;
            accountToDb.DeviceId = _account.DeviceId;
            accountToDb.Phone = _account.Phone;

            Customer customerToDb = new Customer();
            customerToDb.Name = _customer.Name;
            customerToDb.Birth = _customer.Birth;

            using (IDbContextTransaction transaction = _db.Database.BeginTransaction())
            {
                try
                {
                    if (_repository.GetFirstOrDefault(x => x.UserName.Trim().Equals(accountToDb.UserName)) != null
                        || _repository.GetFirstOrDefault(x => x.Phone.Trim().Equals(accountToDb.Phone)) != null)
                    {
                        throw new Exception("This Phone or Account is Used");
                    }
                    _repository.Add(accountToDb);
                    _repository.SaveDbChange();
                    customerToDb.Id = accountToDb.Id;
                    _customerRepository.Add(customerToDb);
                    _customerRepository.SaveDbChange();
                    transaction.Commit();
                }
                catch
                {
                    transaction.Rollback();
                    throw new Exception();
                }
            }

            // query account table in db
            var account = new Account();
            try
            {
                account = _repository.GetFirstOrDefault(x => x.Phone.Equals(user.PhoneNumber));

                //Not in database
                if (account == null) throw new UnauthorizedAccessException();

                //Check if avaliable
                if (account.Status == false) throw new UnauthorizedAccessException($"Oops!!! This account is currently unavailable!!!");

                //Check deviceId for mobile
                if (_account.DeviceId != null)
                {
                    try
                    {
                        account.DeviceId = _account.DeviceId;
                        _repository.Update(account);
                        _repository.SaveDbChange();
                    }
                    catch (Exception)
                    {
                        throw new Exception();
                    }
                }
            }
            catch
            {
                throw new Exception();
            }

            string Name = null;
            string Email = null;

            //Get data for loginViewModel
            try
            {
                Name = _customerRepository.Get(account.Id).Name; ;
                Email = account.UserName;
            }
            catch
            {
                throw new Exception();
            }

            var loginViewModel = new LoginViewModel
            {
                Id = account.Id,
                Role = _roleRepository.Get(account.RoleCode).RoleName,
                UserName = account.UserName,
                Name = Name,
                Phone = account.Phone,
                Email = Email,
                Url = null,
                JwtToken = null
            };
            return loginViewModel;
        }

        //login
        public async Task<LoginViewModel> Login(LoginRequestModel loginRequestModel)
        {
            var userViewModel = await VerifyFirebaseTokenId(loginRequestModel.IdToken, loginRequestModel.deviceId, loginRequestModel.SignInMethod);
            var claims = new List<Claim>
            {
                new(ClaimTypes.Name, userViewModel.Name ?? ""),
                new(ClaimTypes.Email, userViewModel.UserName),
                new(ClaimTypes.Role, userViewModel.Role),
            };

            var accessToken = GenerateAccessToken(claims);
            // var refreshToken = GenerateRefreshToken();

            userViewModel.JwtToken = accessToken;
            return userViewModel;
        }

        public async Task<LoginViewModel> VerifyFirebaseTokenId(string idToken, string deviceId, string SignInMethod)
        {
            FirebaseToken decodedToken;
            try
            {
                decodedToken = await FirebaseAuth.DefaultInstance
                       .VerifyIdTokenAsync(idToken);
            }
            catch
            {
                throw new Exception();
            }
            string uid = decodedToken.Uid;
            var user = await FirebaseAuth.DefaultInstance.GetUserAsync(uid);

            // Query account table in DB
            var account = new Account();
            try
            {
                switch (SignInMethod)
                {
                    case "Email":
                        account = _repository.GetFirstOrDefault(x => x.UserName.Equals(user.Email));
                        break;

                    case "Google":
                        account = _repository.GetFirstOrDefault(x => x.UserName.Equals(user.Email));
                        break;

                    case "Phone":
                        account = _repository.GetFirstOrDefault(x => x.Phone.Equals(user.PhoneNumber));
                        break;

                    default:
                        break;
                }

                //Not in database
                if (account == null) throw new UnauthorizedAccessException();

                //Check if avaliable
                if (account.Status == false) throw new UnauthorizedAccessException($"Oops!!! This account is currently unavailable!!!");

                //Check deviceId for mobile
                if (deviceId != null)
                {
                    try
                    {
                        account.DeviceId = deviceId;
                        _repository.Update(account);
                        _repository.SaveDbChange();
                    }
                    catch (Exception)
                    {
                        throw new Exception();
                    }
                }
            }
            catch
            {
                throw new Exception();
            }

            string Name = null;
            string Email = null;

            //Get data for loginViewModel
            try
            {
                string roleCode = account.RoleCode.Trim();
                switch (roleCode)
                {
                    case "AD":
                        Name = _adminRepository.Get(account.Id).Name;
                        Email = _adminRepository.Get(account.Id).Email;
                        break;

                    case "MOD":
                        Name = _adminRepository.Get(account.Id).Name;
                        Email = _adminRepository.Get(account.Id).Email;
                        break;

                    case "OWN":
                        Name = _ownerRepository.Get(account.Id).Name;
                        Email = _ownerRepository.Get(account.Id).Email;
                        break;

                    case "STF":
                        Name = _staffRepository.Get(account.Id).Name;
                        Email = "";
                        break;

                    case "CUS":
                        Name = _customerRepository.Get(account.Id).Name;
                        Email = account.UserName;
                        break;

                    default:
                        break;
                }
            }
            catch
            {
                throw new Exception();
            }

            var photo = _photoRepository.GetPhotosByIdActorAndPhotoType(account.Id, PhotoTypesConst.Account);
            string url = null;
            if (photo.Count() > 0)
            {
                url = photo.First().Url;
            }

            var loginViewModel = new LoginViewModel
            {
                Id = account.Id,
                Role = _roleRepository.Get(account.RoleCode.Trim()).RoleName,
                UserName = account.UserName,
                Name = Name,
                Phone = account.Phone,
                Email = Email,
                Url = url,
                JwtToken = null
            };

            return loginViewModel;
        }

        public string GenerateAccessToken(IEnumerable<Claim> claims)
        {
            var secretKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("superSecretKey@345"));
            var signinCredentials = new SigningCredentials(secretKey, SecurityAlgorithms.HmacSha256Signature);
            /*var tokeOptions = new JwtSecurityToken(
                claims: claims,
                issuer: "https://securetoken.google.com/tutor-helper-6faa2",
                audience: "tutor-helper-6faa2",
                expires: DateTime.Now.AddDays(5),
                signingCredentials: signinCredentials
            );
            var tokenString = new JwtSecurityTokenHandler().WriteToken(tokeOptions);
         */
            var tokenHandler = new JwtSecurityTokenHandler();
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                //Expires = DateTime.Now.AddDays(5),
                Expires = DateTime.Now.AddDays(30),
                SigningCredentials = signinCredentials,
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            var tokenStr = tokenHandler.WriteToken(token);

            return tokenStr;
        }

        //public string GenerateRefreshToken()
        //{
        //    var randomNumber = new byte[32];
        //    using var rng = RandomNumberGenerator.Create();
        //    rng.GetBytes(randomNumber);
        //    return Convert.ToBase64String(randomNumber);
        //}

        //public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        //{
        //    var tokenValidationParameters = new TokenValidationParameters
        //    {
        //        ValidateAudience =
        //            false, //you might want to validate the audience and issuer depending on your use case
        //        ValidateIssuer = false,
        //        ValidateIssuerSigningKey = true,
        //        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("superSecretKey@345")),
        //        ValidateLifetime = false //here we are saying that we don't care about the token's expiration date
        //    };
        //    var tokenHandler = new JwtSecurityTokenHandler();

        //    var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);

        //    var jwtSecurityToken = securityToken as JwtSecurityToken;
        //    if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256,
        //        StringComparison.InvariantCultureIgnoreCase))
        //        throw new SecurityTokenException("Invalid token");
        //    return principal;
        //}
    }
}