using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/policies")]
    [ApiController]
    public class PoliciesController : ControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> GetAllPolicy()
        {
            var data = await PolicyService.GetAllPolicy("pawnclaw-4b6ba");
            return Ok(data);
        }
    }
}
