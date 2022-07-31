using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Const;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/policies")]
    [ApiController]
    [Authorize(Roles = "Admin")]
    public class PoliciesController : ControllerBase
    {
        //[HttpGet]
        //public async Task<IActionResult> GetAllPolicy()
        //{
        //    var data = await PolicyService.GetAllPolicy(Const.ProjectFirebaseId);
        //    return Ok(data);
        //}

        [HttpGet]
        public async Task<IActionResult> GetPolicy()
        {
            var data = await PolicyService.GetPolicy(Const.ProjectFirebaseId);
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> UpdatePolicy(string newPolicy)
        {
            try
            {
                await PolicyService.AddData(Const.ProjectFirebaseId, newPolicy);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
