using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PawNClaw.Business.Services;
using PawNClaw.Data.Database;
using PawNClaw.Data.Helper;
using PawNClaw.Data.Interface;
using PawNClaw.Data.Parameter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PawNClaw.API.Controllers
{
    [Route("api/admins")]
    [ApiController]
    [Authorize]
    public class AdminsController : ControllerBase
    {
        private readonly AdminService _adminService;
        public AdminsController(AdminService adminService)
        {
            _adminService = adminService;
        }

        [HttpGet]
        [Authorize(Roles = "Admin")]
        public IActionResult GetAdmins([FromQuery] AdminRequestParameter _requestParameter, [FromQuery] PagingParameter _paging)
        {
            var data = _adminService.GetAdmins(_requestParameter, _paging);
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

        [HttpPost]
        [Authorize(Roles = "Admin")]
        public IActionResult Add([FromBody] Admin admin)
        {
            if (_adminService.Add(admin) != -1)
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("{id}")]
        [Authorize(Roles = "Admin,Mod")]
        public IActionResult Update(int Id, [FromBody] AdminRequestParameter admin)
        {
            var adminDb = _adminService.GetAdminById(Id);
            adminDb.Email = admin.Email;
            adminDb.Name = admin.Name;

            if (_adminService.Update(adminDb))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public IActionResult Delete(int id)
        {
            if (_adminService.Delete(id))
            {
                return Ok();
            }
            return BadRequest();
        }

        [HttpPut("restore/{id}")]
        [Authorize(Roles = "Admin")]
        public IActionResult Restore(int id)
        {

            if (_adminService.Restore(id))
            {
                return Ok();
            }
            return BadRequest();
        }
    }
}
