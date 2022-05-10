using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/auth")]
    [ApiController]
    [AllowAnonymous]
    public class AuthsController : ControllerBase
    {
        private readonly AuthService _authService;

        public AuthsController(AuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("sign-in")]
        public async Task<ActionResult<LoginViewModel>> Post([FromBody] LoginRequestModel loginRequestModel)
        {
            return Ok(await _authService.Login(loginRequestModel));
        }

        [HttpPost("sign-up")]
        public async Task<ActionResult<LoginViewModel>> SignUp([FromBody] SignUpRequestModel signUpRequestModel)
        {
            return Ok(await _authService.Register(signUpRequestModel._loginRequestModel, 
                signUpRequestModel._accountRequest, signUpRequestModel._customerRequest));
        }
    }
}
