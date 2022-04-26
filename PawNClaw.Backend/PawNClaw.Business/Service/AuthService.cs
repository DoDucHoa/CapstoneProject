using FirebaseAdmin.Auth;
using Microsoft.IdentityModel.Tokens;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PawNClaw.Business.Service
{
    public class AuthService
    {
        private readonly IAccountRepository _repository;
        private readonly IRoleRepository _roleRepository;

        public AuthService(IAccountRepository userInfoRepository, IRoleRepository roleRepository)
        {
            _repository = userInfoRepository;
            _roleRepository = roleRepository;
        }
        ////register
        //public async task<loginviewmodel> register(loginrequestmodel loginrequestmodel, string universityid, string username)
        //{

        //    var userviewmodel = await verifyfirebasetokenidregister(loginrequestmodel.idtoken, universityid, username);
        //    var claims = new list<claim>
        //    {
        //        new(claimtypes.email, userviewmodel.email),
        //        new(claimtypes.name, userviewmodel.name),
        //    };

        //    var accesstoken = generateaccesstoken(claims);
        //    // var refreshtoken = generaterefreshtoken();

        //    userviewmodel.jwttoken = accesstoken;
        //    return userviewmodel;
        //}

        ////verify for register
        //public async task<loginviewmodel> verifyfirebasetokenidregister(string idtoken, string universityid, string username)
        //{
        //    firebasetoken decodedtoken;
        //    try
        //    {
        //        decodedtoken = await firebaseauth.defaultinstance
        //               .verifyidtokenasync(idtoken);
        //    }
        //    catch
        //    {
        //        throw new exception();
        //    }
        //    string uid = decodedtoken.uid;
        //    var user = await firebaseauth.defaultinstance.getuserasync(uid);

        //    userinfo userinfo = new userinfo();
        //    userinfo.email = user.email;
        //    userinfo.name = username;
        //    userinfo.universityid = universityid;
        //    userinfo.isadmin = false;
        //    userinfo.status = true;

        //    try
        //    {
        //        _repository.add(userinfo);
        //        _repository.savedbchange();
        //    }
        //    catch (exception)
        //    {
        //        throw new exception();
        //    }

        //    // query account table in db
        //    var account = _repository.getfirstordefault(x => x.email == user.email);

        //    if (account == null) throw new unauthorizedaccessexception();

        //    var loginviewmodel = new loginviewmodel
        //    {
        //        id = account.id,
        //        email = account.email,
        //        name = account.name,
        //        jwttoken = null
        //    };
        //    return loginviewmodel;
        //}

        //login
        public async Task<LoginViewModel> Login(LoginRequestModel loginRequestModel)
        {
            var userViewModel = await VerifyFirebaseTokenId(loginRequestModel.IdToken, loginRequestModel.deviceId);
            var claims = new List<Claim>
            {
                new(ClaimTypes.Email, userViewModel.UserName),
                new(ClaimTypes.Role, userViewModel.Role),
            };

            var accessToken = GenerateAccessToken(claims);
            // var refreshToken = GenerateRefreshToken();

            userViewModel.JwtToken = accessToken;
            return userViewModel;
        }

        public async Task<LoginViewModel> VerifyFirebaseTokenId(string idToken, string deviceId)
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
            var account = _repository.GetFirstOrDefault(x => x.UserName == user.Email);


            if (account == null) throw new UnauthorizedAccessException();

            if (deviceId != null)
            {
                try
                {
                    //account.DeviceId = deviceId;
                    _repository.Update(account);
                    _repository.SaveDbChange();
                }
                catch (Exception)
                {
                    throw new Exception();
                }

            }

            var loginViewModel = new LoginViewModel
            {
                Id = account.Id,
                Role = _roleRepository.Get(account.RoleCode).RoleName,
                UserName = account.UserName,
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
                //Expires = DateTime.Now.AddDays(7),
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
