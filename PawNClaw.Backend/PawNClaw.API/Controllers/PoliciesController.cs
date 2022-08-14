using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Const;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/policies")]
    [ApiController]
    //[Authorize(Roles = "Admin")]
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

        [HttpGet("for-customer")]
        public async Task<IActionResult> GetCustomerPolicy()
        {
            var data = await PolicyService.GetCustomerPolicy(Const.ProjectFirebaseId);
            return Ok(data);
        }

        [HttpPost]
        public async Task<IActionResult> UpdatePolicy([FromBody] UpdatePolicyParameter newPolicy)
        {
            try
            {
                await PolicyService.AddData(Const.ProjectFirebaseId, newPolicy.NewPolicy);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }

        [HttpPost("for-customer")]
        public async Task<IActionResult> UpdateCustomerPolicy([FromBody] UpdatePolicyParameter newPolicy)
        {
            try
            {
                await PolicyService.UpdateCustomerPolicy(Const.ProjectFirebaseId, newPolicy.NewPolicy);
                return Ok();
            }
            catch (Exception ex)
            {
                return BadRequest(ex);
            }
        }
    }
}
