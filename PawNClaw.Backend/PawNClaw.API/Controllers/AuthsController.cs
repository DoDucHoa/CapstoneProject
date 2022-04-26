using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Service;
using PawNClaw.Data.Helper;
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
        public async Task<ActionResult<LoginViewModel>> Post([FromQuery] LoginRequestModel loginRequestModel)
        {
            return Ok(await _authService.Login(loginRequestModel));
        }
    }
}
