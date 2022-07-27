using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using static PawNClaw.Data.Parameter.StaffRequestParameter;

namespace PawNClaw.API.Controllers
{
    [Route("api/staffs")]
    [ApiController]
    [Authorize]
    public class StaffController : ControllerBase
    {
        private readonly StaffServicecs _staffServicecs;

        public StaffController(StaffServicecs staffServicecs)
        {
            _staffServicecs = staffServicecs;
        }

        [HttpPost]
        [Authorize(Roles = "Admin,Mod")]
        public async Task<IActionResult> Add([FromBody] CreateStaffParameter staff)
        {
            try
            {
                await _staffServicecs.AddAsync(staff);
                return Ok();
            }
            catch(Exception e)
            {

                return BadRequest(e);
            }
        }
    }
}
