using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Helper;
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
        [Authorize(Roles = "Admin,Mod,Owner")]
        public async Task<IActionResult> Add([FromBody] CreateStaffParameter staff)
        {
            try
            {
                var data = await _staffServicecs.AddAsync(staff);
                return Ok(data);
            }
            catch (Exception e)
            {

                return BadRequest(e);
            }
        }

        [HttpGet("{id}")]
        public IActionResult GetStaffById(int id)
        {
            try
            {
                var data = _staffServicecs.GetById(id);
                return Ok(data);
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpGet("center")]
        public IActionResult getStaffByCenter([FromQuery] int centerId, [FromQuery] string name, [FromQuery] bool? status, [FromQuery] PagingParameter paging)
        {
            try
            {
                var data = _staffServicecs.GetByCenterId(centerId,name, status, paging);
                var metadata = new
                {
                    data.TotalCount,
                    data.PageSize,
                    data.CurrentPage,
                    data.TotalPages,
                    data.HasNext,
                    data.HasPrevious
                };
                return Ok(new { data, metadata });
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut]
        [Authorize(Roles = "Admin,Mod,Owner,Staff")]
        public IActionResult updateStaff([FromBody] UpdateStaffParameter staff)
        {
            try
            {
                _staffServicecs.UpdateById(staff);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }

        [HttpPut("update-status/{id}")]
        [Authorize(Roles = "Admin,Mod,Owner")]
        public IActionResult BanStaff(int id)
        {
            try
            {
                _staffServicecs.banStaff(id);
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }
    }
}
